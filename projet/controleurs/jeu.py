from model.model_pg import get_random_briques, get_brique_by_id, get_new_random_brique

# Valeurs par défaut si elles ne sont pas présentes dans REQUEST_VARS
if 'rows' not in REQUEST_VARS:
    REQUEST_VARS['rows'] = 9  # Valeur par défaut pour rows
if 'cols' not in REQUEST_VARS:
    REQUEST_VARS['cols'] = 8  # Valeur par défaut pour cols
if 'mode' not in REQUEST_VARS:
    REQUEST_VARS['mode'] = 'facile'  # Valeur par défaut pour mode
if 'max_turns' not in REQUEST_VARS:
    REQUEST_VARS['max_turns'] = 20  # Valeur par défaut pour max_turns

# Function to generate target cells in the grid
def generate_target_cells(rows, cols):
    import random
    grid = [[0 for _ in range(cols)] for _ in range(rows)]
    total_cells = rows * cols
    target_count = random.randint(int(0.1 * total_cells), int(0.2 * total_cells))

    def is_valid_cell(x, y):
        if 0 <= x < rows and 0 <= y < cols and grid[x][y] == 0:
            neighbors = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
            return any(0 <= nx < rows and 0 <= ny < cols and grid[nx][ny] == 1 for nx, ny in neighbors)
        return False

    x, y = random.randint(0, rows-1), random.randint(0, cols-1)
    grid[x][y] = 1
    targets = [(x, y)]
    
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

    target_cells = {}
    for i in range(rows):
        target_cells[i] = [j for j in range(cols) if grid[i][j] == 1]
    
    REQUEST_VARS['target_cells'] = target_cells
    return grid

# Process POST data for rows, cols, mode, and max_turns if present
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

if 'mode' in POST:
    REQUEST_VARS['mode'] = POST['mode'][0]

if 'max_turns' in POST:
    try:
        max_turns = int(POST['max_turns'][0])
        if max_turns > 0:
            REQUEST_VARS['max_turns'] = max_turns
        else:
            REQUEST_VARS['error'] = "Max turns must be greater than 0."
    except (ValueError, IndexError):
        REQUEST_VARS['error'] = "Please enter a valid numeric value for max turns."

# Generate grid with target cells only if not already in session or explicitly requested
if 'grid' not in SESSION or 'generate_grid' in POST:
    rows, cols = REQUEST_VARS['rows'], REQUEST_VARS['cols']
    grid = generate_target_cells(rows, cols)
    SESSION['grid'] = grid
else:
    grid = SESSION['grid']

# Initialize the game state
if 'turns' not in SESSION:
    SESSION['turns'] = 0
if 'score' not in SESSION:
    SESSION['score'] = 0
if 'placed_briques' not in SESSION:
    SESSION['placed_briques'] = []

# Function to check if a brick can be placed at the specified location
def can_place_brique(grid, brique, x, y):
    brique_id, longueur, largeur = brique
    if x + longueur > len(grid) or y + largeur > len(grid[0]):
        return False
    for i in range(longueur):
        for j in range(largeur):
            if grid[x + i][y + j] != 0:
                return False
    return True

# Process POST data for placing a brick
if 'brique' in POST and 'x' in POST and 'y' in POST:
    try:
        brique_id = POST['brique'][0]
        x = int(POST['x'][0])
        y = int(POST['y'][0])
        res = get_brique_by_id(SESSION['CONNEXION'], brique_id)
        if res:
            brique = res[0]
            if can_place_brique(grid, brique, x, y):
                for i in range(brique[2]):
                    for j in range(brique[3]):
                        grid[x + i][y + j] = brique_id
                SESSION['placed_briques'].append((brique_id, x, y))
                SESSION['score'] += 1
            else:
                SESSION['score'] += 1  # Penalty for invalid placement
        else:
            REQUEST_VARS['error'] = "Invalid brique ID."
    except (ValueError, IndexError):
        REQUEST_VARS['error'] = "Please enter valid numeric values for x and y."

# Check if the game is over
if SESSION['turns'] >= REQUEST_VARS['max_turns']:
    SESSION['score'] = 999
    REQUEST_VARS['game_over'] = True
else:
    SESSION['turns'] += 1

# Update REQUEST_VARS with the game state
REQUEST_VARS['grid'] = grid
REQUEST_VARS['turns'] = SESSION['turns']
REQUEST_VARS['score'] = SESSION['score']
REQUEST_VARS['placed_briques'] = SESSION['placed_briques']

# Initialize the pioche
if 'pioche' not in SESSION:
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
        
        new_brique_res = get_new_random_brique(SESSION['CONNEXION'], SESSION['removed_briques'])
        if new_brique_res:
            new_brique = new_brique_res[0]
            SESSION['pioche'].append(new_brique[0])
            message = f"{message} Nouvelle brique ajoutée: {new_brique[0]}"
    else:
        message = "Aucune brique avec cet id."
    print(message)

    REQUEST_VARS['message_brique'] = message