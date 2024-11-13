from model.model_pg import count_instances, top_5_couleurs, scores_per_joueuse, max_nb_pieces_defaussees, moy_tours_date, top_3_parties_pieces

res = count_instances(SESSION['CONNEXION'], 'usine')
nb_series = res[0][0] # result is a list of tuples with attributes
if nb_series > 0:
    message = f"Actuellement {nb_series} usines dans la base."
else:
    message = "Aucune usine dans la base."
print(message)

REQUEST_VARS['message_usine'] = message

res = count_instances(SESSION['CONNEXION'], 'brique')
nb_series = res[0][0] # result is a list of tuples with attributes
if nb_series > 0:
    message = f"Actuellement {nb_series} briques dans la base."
else:
    message = "Aucun brique dans la base."
print(message)

REQUEST_VARS['message_brique'] = message

res = count_instances(SESSION['CONNEXION'], 'partie')
nb_series = res[0][0] # result is a list of tuples with attributes
if nb_series > 0:
    message = f"Actuellement {nb_series} parties dans la base."
else:
    message = "Aucune partie dans la base."
print(message)

REQUEST_VARS['message_partie'] = message

res = top_5_couleurs(SESSION['CONNEXION'])
if res:
    couleurs = [couleur[0] for couleur in res]
    message = f"Les 5 couleurs les plus utilisées sont : {', '.join(couleurs)}."
else:
    message = "Aucune brique dans la base."
print(message)

REQUEST_VARS['message_couleur'] = message

res = scores_per_joueuse(SESSION['CONNEXION'])
if res:
    scores = [f"{score[0]} : min = {score[1]}, max = {score[2]}" for score in res]
    message = f"Scores par joueuse : {', '.join(scores)}."
else:
    message = "Aucun score dans la base."
print(message)

REQUEST_VARS['message_score'] = message

res = max_nb_pieces_defaussees(SESSION['CONNEXION'])
if res:
    max_defausse = res[0][0]
    message = f"Le nombre maximal de pièces défaussées est {max_defausse}."
else: 
    message = "Aucune pièce défaussée."
print(message)

REQUEST_VARS['message_max_defausse'] = message

res = moy_tours_date(SESSION['CONNEXION'])
if res:
    moy_tours = res[0][0]
    message = f"La moyenne de tours par partie est de {moy_tours}."
else:
    message = "Aucune partie dans la base."
print(message)

REQUEST_VARS['message_moy_tours'] = message

res = top_3_parties_pieces(SESSION['CONNEXION'])
if res:
    parties = [f"{partie[0]} : {partie[1]} : {partie[2]}" for partie in res] #check indices
    message = f"Les 3 parties avec les plus grandes pièces sont : {', '.join(parties)}."
else:
    message = "Aucune partie dans la base."
print(message)

REQUEST_VARS['message_parties_pieces'] = message


