import psycopg
from psycopg import sql
from logzero import logger

def execute_select_query(connexion, query, params=[]):
    """
    Méthode générique pour exécuter une requête SELECT (qui peut retourner plusieurs instances).
    Utilisée par des fonctions plus spécifiques.
    """
    with connexion.cursor() as cursor:
        try:
            cursor.execute(query, params)
            result = cursor.fetchall()
            return result 
        except psycopg.Error as e:
            logger.error(e)
    return None

def execute_other_query(connexion, query, params=[]):
    """
    Méthode générique pour exécuter une requête INSERT, UPDATE, DELETE.
    Utilisée par des fonctions plus spécifiques.
    """
    with connexion.cursor() as cursor:
        try:
            cursor.execute(query, params)
            result = cursor.rowcount
            return result 
        except psycopg.Error as e:
            logger.error(e)
    return None

def get_instances(connexion, nom_table):
    """
    Retourne les instances de la table nom_table
    String nom_table : nom de la table
    """
    query = sql.SQL('SELECT * FROM {table}').format(table=sql.Identifier(nom_table), )
    return execute_select_query(connexion, query)

def count_instances(connexion, nom_table):
    """
    Retourne le nombre d'instances de la table nom_table
    String nom_table : nom de la table
    """
    query = sql.SQL('SELECT COUNT(*) AS nb FROM {table}').format(table=sql.Identifier(nom_table))
    return execute_select_query(connexion, query)

def top_5_couleurs(connexion):
    """
    Retourne les 5 couleurs les plus utilisées
    """
    query = sql.SQL('SELECT couleur, COUNT(*) AS nb FROM brique GROUP BY couleur ORDER BY nb DESC LIMIT 5')
    return execute_select_query(connexion, query)

def scores_per_joueuse(connexion):
    """
    Retourne les scores par joueuse
    """
    query = sql.SQL('SELECT prenom_J, MIN(CAST(score AS INTEGER)) AS score_min, MAX(CAST(score AS INTEGER)) AS score_max FROM SCORES GROUP BY prenom_J;')
    return execute_select_query(connexion, query)

def max_nb_pieces_defaussees(connexion):
    """
    Retourne le nombre de pièces défaussées
    """
    query = sql.SQL('SELECT COUNT(*) AS pieces_defausses, date_debut FROM Tour WHERE description_Action like \'défaussée\' GROUP BY date_debut ORDER BY pieces_defausses DESC LIMIT 1;')
    return execute_select_query(connexion, query)

def moy_tours_date(connexion):
    """
    Retourne le nombre de tours par partie
    """
    query = sql.SQL('SELECT COUNT(*) / COUNT(DISTINCT numero_T) AS moyenne_tours, EXTRACT(YEAR FROM date_debut::DATE) AS annee,'
    'EXTRACT(MONTH FROM date_debut::DATE) AS mois '
    'FROM Tour GROUP BY annee, mois;')
    return execute_select_query(connexion, query)

def top_3_parties_pieces(connexion): #maybe check if the data is well represented
    """
    Retourne les 3 parties avec le plus grandes pièces
    """
    query = sql.SQL('SELECT P.date_debut, B.id_B, '
   '(CAST(B.largeur AS NUMERIC) * CAST(B.longueur AS NUMERIC)) AS superficie, '
   'COUNT(*) AS nombre_pieces_utilisees '
   'FROM Tour T '
   'JOIN Brique B ON T.id_B = B.id_B '
   'JOIN Partie P ON T.date_debut = P.date_debut '
   'GROUP BY P.date_debut, B.id_B '
   'ORDER BY superficie DESC, nombre_pieces_utilisees DESC '
   'LIMIT 3;')
    return execute_select_query(connexion, query)

#grille fixe

def get_random_briques(connexion):
    query = sql.SQL("SELECT id_B, longueur, largeur FROM Brique WHERE longueur <= 2 OR largeur <= 2 ORDER BY RANDOM() LIMIT 4")
    return execute_select_query(connexion, query)

def get_brique_by_id(connexion, brique_id):
    query = sql.SQL("SELECT id_B, couleur, longueur, largeur, forme, mots_cles FROM brique WHERE id_B = %s")
    return execute_select_query(connexion, query, [brique_id])

def get_new_random_brique(connexion, exclude_ids):
    query = sql.SQL("SELECT id_B FROM Brique WHERE id_B NOT IN %s ORDER BY RANDOM() LIMIT 1")
    return execute_select_query(connexion, query, (tuple(exclude_ids),))