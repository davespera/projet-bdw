
"""
Ficher initialisation (eg, constantes chargées au démarrage dans la session)
"""

from datetime import datetime
from os import path

SESSION['APP'] = "Lego Bataille"
SESSION['BASELINE'] = "Bataille de Lego passionante !"
SESSION['CURRENT_YEAR'] = datetime.now().year
SESSION['DATE'] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")