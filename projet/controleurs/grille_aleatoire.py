from model.model_pg import get_random_briques, get_brique_by_id, get_new_random_brique

if 'rows' not in REQUEST_VARS:
    REQUEST_VARS['rows'] = 9  # Default value for rows
if 'cols' not in REQUEST_VARS:
    REQUEST_VARS['cols'] = 8  # Default value for columns
if 'target_cells' not in REQUEST_VARS:
    target_cells = {
        1: [3, 4],
        2: [2, 5],
        3: [1, 6],
        4: [0, 7],
        5: [1, 6],
        6: [2, 5],
        7: [3, 4],
    }
    REQUEST_VARS['target_cells'] = target_cells

if 'rows' in POST and 'cols' in POST:
    try:
        rows = int(POST['rows'][0])
        cols = int(POST['cols'][0])
        
        # Validate inputs
        if rows > 0 and cols > 0:
            REQUEST_VARS['rows'] = rows
            REQUEST_VARS['cols'] = cols

            # Optionally, regenerate target cells dynamically
            target_cells = {
                1: [3, 4] if rows > 1 and cols > 4 else [],
                2: [2, 5] if rows > 2 and cols > 5 else [],
                3: [1, 6] if rows > 3 and cols > 6 else [],
                # Add more logic to adjust targets as needed
            }
            REQUEST_VARS['target_cells'] = target_cells
        else:
            REQUEST_VARS['error'] = "Les rangées et les colonnes doivent être supérieures à 0."
    except ValueError:
        REQUEST_VARS['error'] = "Veuillez saisir des valeurs valides pour les rangées et les colonnes."

# Initialisation de la pioche
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
        
        # Get a new random brique that is not in the removed list
        new_brique_res = get_new_random_brique(SESSION['CONNEXION'], SESSION['removed_briques'])
        if new_brique_res:
            new_brique = new_brique_res[0]
            SESSION['pioche'].append(new_brique[0])  # Append only the brique ID
            message = f"{message} Nouvelle brique ajoutée: {new_brique[0]}"
    else:
        message = "Aucune brique avec cet id."
    print(message)

    REQUEST_VARS['message_brique'] = message