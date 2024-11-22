from model.model_pg import get_random_briques, get_brique_by_id, get_new_random_brique

# Initialisation de la pioche
if 'pioche' not in SESSION:
    res = get_random_briques(SESSION['CONNEXION'])
    if res:
        briques = [brique[0] for brique in res]  
        SESSION['pioche'] = briques
    else:
        SESSION['pioche'] = []
    REQUEST_VARS['message_rand_briques'] = SESSION['pioche']
else:
    REQUEST_VARS['message_rand_briques'] = SESSION['pioche']

if 'brique' in POST:
    res = get_brique_by_id(SESSION['CONNEXION'], POST['brique'][0])
    if res:
        brique = res[0]
        message = f"La brique {brique[0]} est de couleur {brique[1]}, de longueur {brique[2]} et de largeur {brique[3]}."
        SESSION['pioche'].remove(brique[0])
        #new_brique = get_new_random_brique(SESSION['CONNEXION'], brique[0])
    else:
        message = "Aucune brique avec cet id."
    print(message)

    REQUEST_VARS['message_brique'] = message