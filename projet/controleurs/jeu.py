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

    def is_valid_cell(x, y):
        if 0 <= x < rows and 0 <= y < cols and grid[x][y] == 0:
            neighbors = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
            return any(0 <= nx < rows and 0 <= ny < cols and grid[nx][ny] == 1 for nx, ny in neighbors)
        return False

    x, y = random.randint(0, rows - 1), random.randint(0, cols - 1)
    grid[x][y] = 1
    targets = [(x, y)]

    while len(targets) < target_count:
        placed = False

        for start_x, start_y in random.sample(targets, len(targets)):
            directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
            random.shuffle(directions)

            for dx, dy in directions:
                nx, ny = start_x + dx, start_y + dy
                if is_valid_cell(nx, ny):
                    grid[nx][ny] = 1
                    targets.append((nx, ny))
                    placed = True
                    break

            if placed:
                break

        if not placed:
            for _ in range(100):
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

        if not placed:
            print(f"Warning: Unable to place additional targets. Current count: {len(targets)}")
            break

    target_cells = {i: [j for j in range(cols) if grid[i][j] == 1] for i in range(rows)}
    REQUEST_VARS['target_cells'] = target_cells
    return grid

# Handle POST data for rows and cols
if 'rows' in POST and 'cols' in POST:
    try:
        rows = int(POST['rows'][0])
        cols = int(POST['cols'][0])
        if rows > 0 and cols > 0:
            REQUEST_VARS['rows'], REQUEST_VARS['cols'] = rows, cols
            SESSION['rows'], SESSION['cols'] = rows, cols
            if 'grid' in SESSION:
                del SESSION['grid']
        else:
            REQUEST_VARS['error'] = "Rows and columns must be greater than 0."
    except (ValueError, IndexError):
        REQUEST_VARS['error'] = "Please enter valid numeric values for rows and columns."

# Retrieve rows and cols from SESSION or REQUEST_VARS
rows = SESSION.get('rows', REQUEST_VARS.get('rows', 9))
cols = SESSION.get('cols', REQUEST_VARS.get('cols', 8))
REQUEST_VARS['rows'], REQUEST_VARS['cols'] = rows, cols

# Generate grid if not in SESSION or after POST update
if 'grid' not in SESSION:
    grid = generate_target_cells(rows, cols)
    SESSION['grid'] = grid
    SESSION['target_cells'] = REQUEST_VARS['target_cells']
else:
    grid = SESSION['grid']
    REQUEST_VARS['target_cells'] = SESSION['target_cells']

REQUEST_VARS['grid'] = grid

# Pioche initialization
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

# Process brique POST data
if 'brique' in POST:
    # Retrieve brique details
    res = get_brique_by_id(SESSION['CONNEXION'], POST['brique'][0])
    if res:
        brique = res[0]
        brique_id, color, width, height = brique[0], brique[1], brique[2], brique[3]
        message = f"La brique {brique_id} est de couleur {color}, de longueur {width} et de largeur {height}."
        SESSION['pioche'].remove(brique_id)
        SESSION['removed_briques'].append(brique_id)
        SESSION['turn_counter'] += 1
        REQUEST_VARS['turn_counter'] = SESSION['turn_counter']

        # Process block placement based on coordinates
        if 'coord_x' in POST and 'coord_y' in POST:
            try:
                coord_x = int(POST['coord_x'][0])  # Starting row
                coord_y = int(POST['coord_y'][0])  # Starting column

                # Get the grid from REQUEST_VARS
                grid = REQUEST_VARS['grid']

                # Check if the brique fits entirely within the grid bounds
                if coord_x + height > len(grid) or coord_y + width > len(grid[0]):
                    message = f"Erreur: La brique ({width}x{height}) dépasse les limites de la grille."
                else:
                    valid_placement = True

                    # Check if all cells are valid for placement
                    for x in range(coord_x, coord_x + height):
                        for y in range(coord_y, coord_y + width):
                            if grid[x][y] not in [0, 1]:  # Only empty or target cells are valid
                                valid_placement = False
                                break
                        if not valid_placement:
                            break

                    if valid_placement:
                        # Fill or complete all cells the brique occupies
                        for x in range(coord_x, coord_x + height):
                            for y in range(coord_y, coord_y + width):
                                if grid[x][y] == 0:  # Empty cell
                                    grid[x][y] = 2  # Mark as filled non-target
                                elif grid[x][y] == 1:  # Target cell
                                    grid[x][y] = 3  # Mark as filled target

                        # Update REQUEST_VARS with the modified grid
                        REQUEST_VARS['grid'] = grid
                        SESSION['grid'] = grid  # Optionally update SESSION to persist state
                        message = f"Brique placée à partir de ({coord_x}, {coord_y}) couvrant {width}x{height}."
                    else:
                        message = "Erreur: Certaines cellules dans la zone sélectionnée ne sont pas valides pour le placement."
            except (ValueError, IndexError):
                message = "Erreur: Coordonnées ou dimensions invalides."

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

    # Update the message in REQUEST_VARS
    REQUEST_VARS['message_brique'] = message
