from model.model_pg import get_random_briques, get_random_briques_diff, get_brique_by_id, get_new_random_brique, get_new_random_brique_diff



# Valeurs par défaut si elles ne sont pas présentes dans REQUEST_VARS
if 'rows' not in REQUEST_VARS:
    REQUEST_VARS['rows'] = 9  # Valeur par défaut pour rows
if 'cols' not in REQUEST_VARS:
    REQUEST_VARS['cols'] = 8  # Valeur par défaut pour cols

if 'facile' in POST:
    SESSION['mode'] = 'facile'
elif 'difficile' in POST:
    SESSION['mode'] = 'difficile'



# Function to generate target cells in the grid
def generate_target_cells(rows, cols):
    # Initialize the grid
    import  random
    grid = [[0 for _ in range(cols)] for _ in range(rows)]
    total_cells = rows * cols
    # Calculate a realistic target count based on grid size
    target_count = random.randint(int(0.1 * total_cells), int(0.2 * total_cells))

    # Function to check if a cell is valid (empty and adjacent to another target cell)
    def is_valid_cell(x, y):
        if 0 <= x < rows and 0 <= y < cols and grid[x][y] == 0:
            neighbors = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
            return any(0 <= nx < rows and 0 <= ny < cols and grid[nx][ny] == 1 for nx, ny in neighbors)
        return False

    # Add the first target cell
    x, y = random.randint(0, rows-1), random.randint(0, cols-1)
    grid[x][y] = 1  # Mark as target
    targets = [(x, y)]
    
    # Add the remaining target cells
    while len(targets) < target_count:
        start_x, start_y = random.choice(targets)
        directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        random.shuffle(directions)
        
        added = False
        for dx, dy in directions:
            nx, ny = start_x + dx, start_y + dy
            if is_valid_cell(nx, ny):
                grid[nx][ny] = 1
                targets.append((nx, ny))
                added = True
                break
        
        if not added and len(targets) < target_count:
            print(f"Warning: Unable to generate enough target cells. Currently placed {len(targets)} targets.")
            break

    # Convert grid to target_cells format for template
    target_cells = {}
    for i in range(rows):
        target_cells[i] = [j for j in range(cols) if grid[i][j] == 1]
    
    REQUEST_VARS['target_cells'] = target_cells
    return grid

# Process POST data for rows and cols if present
if 'rows' in POST and 'cols' in POST:
    try:
        rows = int(POST['rows'][0])
        cols = int(POST['cols'][0])
        if rows > 0 and cols > 0:
            REQUEST_VARS['rows'] = rows
            REQUEST_VARS['cols'] = cols
        else:
            REQUEST_VARS['error'] = "Rows and columns must be greater than 0."
    except (ValueError, IndexError):
        REQUEST_VARS['error'] = "Please enter valid numeric values for rows and columns."

# Debugging: Print out REQUEST_VARS to see if rows and cols are set correctly
print("REQUEST_VARS:", REQUEST_VARS)  # Debugging line to ensure rows and cols are present
print("Target Cells:", REQUEST_VARS.get('target cells'))  # Ensure target cells are defined correctly

# Generate grid with target cells
rows, cols = REQUEST_VARS['rows'], REQUEST_VARS['cols']
grid = generate_target_cells(rows, cols)

# Initialisation de la pioche
if 'pioche' not in SESSION:
    if SESSION['mode'] == 'facile':
        res = get_random_briques(SESSION['CONNEXION'])
    elif SESSION['mode'] == 'difficile':
        res = get_random_briques_diff(SESSION['CONNEXION'])
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
        
        # Get a new random brique that is not in the removed list
        if SESSION['mode'] == 'facile':
            new_brique_res = get_new_random_brique(SESSION['CONNEXION'], SESSION['removed_briques'])
        elif SESSION['mode'] == 'difficile':
            new_brique_res = get_new_random_brique_diff(SESSION['CONNEXION'], SESSION['removed_briques'])
        if new_brique_res:
            new_brique = new_brique_res[0]
            SESSION['pioche'].append(new_brique[0])  # Append only the brique ID
            message = f"{message} Nouvelle brique ajoutée: {new_brique[0]}"
    else:
        message = "Aucune brique avec cet id."
    print(message)

    REQUEST_VARS['message_brique'] = message
