from model.model_pg import get_random_briques, get_random_briques_diff, get_brique_by_id, get_new_random_brique, get_new_random_brique_diff



# Valeurs par défaut si elles ne sont pas présentes dans REQUEST_VARS
if 'rows' not in REQUEST_VARS:
    REQUEST_VARS['rows'] = 9  # Valeur par défaut pour rows
if 'cols' not in REQUEST_VARS:
    REQUEST_VARS['cols'] = 8  # Valeur par défaut pour cols

if 'difficulty' in POST:
    SESSION['difficulty'] = POST['difficulty'][0]

if 'turn_counter' not in SESSION:
    SESSION['turn_counter'] = 0


# Function to generate target cells in the grid
def generate_target_cells(rows, cols):
    import random

    # Initialize the grid
    grid = [[0 for _ in range(cols)] for _ in range(rows)]
    total_cells = rows * cols
    target_count = random.randint(int(0.1 * total_cells), int(0.2 * total_cells))

    # Function to check if a cell is valid (empty and adjacent to another target cell)
    def is_valid_cell(x, y):
        if 0 <= x < rows and 0 <= y < cols and grid[x][y] == 0:
            neighbors = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
            return any(0 <= nx < rows and 0 <= ny < cols and grid[nx][ny] == 1 for nx, ny in neighbors)
        return False

    # Start by placing the first target randomly
    x, y = random.randint(0, rows - 1), random.randint(0, cols - 1)
    grid[x][y] = 1
    targets = [(x, y)]

    while len(targets) < target_count:
        placed = False

        # Attempt to expand from existing targets
        random_x, random_y = random.choice(targets)
        directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        random.shuffle(directions)
        for dx, dy in directions:
            nx, ny = random_x + dx, random_y + dy
            if is_valid_cell(nx, ny):
                grid[nx][ny] = 1
                targets.append((nx, ny))
                placed = True
                break
            if placed:
                break


    target_cells = {}
    for x, y in targets:
        if x not in target_cells:
            target_cells[x] = []
        target_cells[x].append(y)
    # Convert grid to target_cells format for template
    REQUEST_VARS['target_cells'] = target_cells
    return grid


# Process POST data for rows and cols if present
if 'rows' in POST and 'cols' in POST:
    try:
        rows = int(POST['rows'][0])
        cols = int(POST['cols'][0])
        print(f"POST data processed: rows={POST.get('rows')}, cols={POST.get('cols')}")
        if rows > 0 and cols > 0:
            # Update REQUEST_VARS and SESSION with new values
            REQUEST_VARS['rows'], REQUEST_VARS['cols'] = rows, cols
            SESSION['rows'], SESSION['cols'] = rows, cols
            
            # Clear outdated grid
            if 'grid' in SESSION:
                del SESSION['grid']
        else:
            REQUEST_VARS['error'] = "Rows and columns must be greater than 0."
    except (ValueError, IndexError):
        REQUEST_VARS['error'] = "Please enter valid numeric values for rows and columns."

# Determine rows and cols from SESSION or REQUEST_VARS
rows = SESSION.get('rows', REQUEST_VARS.get('rows', 9))
cols = SESSION.get('cols', REQUEST_VARS.get('cols', 8))
REQUEST_VARS['rows'], REQUEST_VARS['cols'] = rows, cols

# Generate grid if not already in SESSION or after POST update
if 'grid' not in SESSION:
    print(f"Generating grid with rows={rows}, cols={cols}")
    grid = generate_target_cells(rows, cols)
    SESSION['grid'] = grid
    SESSION['target_cells'] = REQUEST_VARS['target_cells']
else:
    grid = SESSION['grid']
    REQUEST_VARS['target_cells'] = SESSION['target_cells']

# Debugging: Print out REQUEST_VARS to verify values
print(f"Rows: {rows}, Cols: {cols}")
print("REQUEST_VARS:", REQUEST_VARS)
print("Target Cells:", REQUEST_VARS.get('target_cells'))

# Initialisation de la pioche
if 'pioche' not in SESSION:
    if SESSION.get('difficulty') == "difficile":
        res = get_random_briques_diff(SESSION['CONNEXION'])
    else:
        res = get_random_briques(SESSION['CONNEXION'])

    if res:
        briques = [brique[0] for brique in res]  
        SESSION['pioche'] = briques
        SESSION['removed_briques'] = []
    else:
        SESSION['pioche'] = []
        SESSION['removed_briques'] = []
    REQUEST_VARS['message_rand_briques'] = SESSION['pioche']
else:
    REQUEST_VARS['message_rand_briques'] = SESSION['pioche']

if 'brique' in POST:
    res = get_brique_by_id(SESSION['CONNEXION'], POST['brique'][0])
    if res:
        brique = res[0]
        message = f"La brique {brique[0]} est de couleur {brique[1]}, de longueur {brique[2]} et de largeur {brique[3]}."
        SESSION['pioche'].remove(brique[0])
        SESSION['removed_briques'].append(brique[0])
        SESSION['turn_counter'] += 1
        REQUEST_VARS['turn_counter'] = SESSION['turn_counter']
        
        # Get a new random brique that is not in the removed list
        if SESSION.get('difficulty') == "difficile":
            new_brique_res = get_new_random_brique_diff(SESSION['CONNEXION'], SESSION['removed_briques'])
        else:
            new_brique_res = get_new_random_brique(SESSION['CONNEXION'], SESSION['removed_briques'])

        if new_brique_res:
            new_brique = new_brique_res[0]
            SESSION['pioche'].append(new_brique[0])  # Append only the brique ID
            message = f"{message} Nouvelle brique ajoutée: {new_brique[0]}"
    else:
        message = "Aucune brique avec cet id."
    print(message)

    REQUEST_VARS['message_brique'] = message


