# Quota Social Linux

Version Linux de l'application **Quota Social** basee sur `pywebview`.

## Fonctionnalites

- ouverture du site `https://quotasocial.fr` dans une fenetre native
- verification de version via `https://quotasocial.fr/version.txt`
- popup si l'application n'est plus a jour
- notification Linux via `notify-send` quand disponible

## Fichiers

- `main.py` : point d'entree de l'application
- `requirements.txt` : dependances Python pour Linux

## Installation des dependances

Sous Debian ou Ubuntu :

```bash
python3 -m pip install -r requirements.txt
```

Selon l'environnement Linux, `pywebview` peut avoir besoin de bibliotheques systeme supplementaires. Cette version utilise le backend Qt :

```bash
python3 -m pip install "pywebview[qt]==6.2.1"
```

## Lancer l'application

```bash
python3 main.py
```

## Build d'un binaire Linux

Le build doit etre fait depuis Linux, pas depuis Windows.

```bash
python3 -m pip install pyinstaller
python3 -m PyInstaller --onefile --windowed --name quota-social main.py
```

Le binaire genere se trouvera dans `dist/`.

## Paquet Debian

Si tu veux ensuite distribuer l'application avec `apt`, il faudra :

1. creer un paquet `.deb`
2. creer un depot APT
3. publier ce depot sur ton site ou un hebergement statique

Pour un premier test, tu peux aussi distribuer directement un `.deb` et l'installer avec :

```bash
sudo apt install ./quota-social.deb
```

## Mise a jour

L'application compare `APP_VERSION` avec le contenu de `version.txt`.
Si les versions sont differentes, l'utilisateur voit :

- un popup
- une notification systeme si disponible

## Licence

Ce projet est distribue sous licence MIT. Voir le fichier [LICENSE](LICENSE).
