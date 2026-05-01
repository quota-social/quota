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

La methode la plus simple consiste a :

1. generer le binaire Linux
2. construire un paquet `.deb`
3. installer le paquet localement ou le publier ensuite dans un depot APT

### 1. Generer le binaire

```bash
python3 -m pip install pyinstaller
python3 -m PyInstaller --onefile --windowed --name quota-social main.py
```

Le binaire doit ensuite exister ici :

```text
dist/quota-social
```

### 2. Construire le `.deb`

Depuis Linux :

```bash
chmod +x build-deb.sh
./build-deb.sh
```

Le paquet sera genere ici :

```text
pkg-deb/quota-social_1.0.1_amd64.deb
```

### 3. Installer le `.deb`

```bash
sudo apt install ./pkg-deb/quota-social_1.0.1_amd64.deb
```

### Structure du paquet

- `pkg-deb/DEBIAN/control` : metadonnees du paquet
- `pkg-deb/DEBIAN/postinst` : script execute apres installation
- `pkg-deb/usr/bin/quota-social` : lanceur systeme
- `pkg-deb/usr/share/applications/quota-social.desktop` : raccourci menu

Si tu veux ensuite un vrai :

```bash
sudo apt install quota-social
```

il faudra publier ce `.deb` dans un depot APT avec un index `Packages`.

## Depuis Windows avec GitHub

Tu peux tout preparer depuis Windows puis laisser GitHub construire le paquet Linux.

### Ce que tu fais sur Windows

1. Mets tous les fichiers de ce dossier dans ton depot GitHub.
2. Envoie-les sur la branche `main`.
3. Active GitHub Pages avec la source `GitHub Actions`.
4. Attends la fin du workflow GitHub Actions.

### Commandes Windows a lancer

Dans ton depot local :

```powershell
git add .
git commit -m "Add Linux Debian and APT packaging"
git push
```

### Ce que GitHub fera automatiquement

- construire le binaire Linux sur Ubuntu
- construire le paquet `.deb`
- generer le depot APT
- publier le depot sur GitHub Pages

### Installation finale cote Linux

Quand le workflow est termine, l'utilisateur Linux peut faire :

```bash
echo "deb [trusted=yes] https://quota-social.github.io/quota stable main" | sudo tee /etc/apt/sources.list.d/quota-social.list
sudo apt update
sudo apt install quota-social
```

### Important

Le nom du paquet est `quota-social`.
N'utilise pas `quota`, car ce nom existe deja dans Debian et Ubuntu.

## Mise a jour

L'application compare `APP_VERSION` avec le contenu de `version.txt`.
Si les versions sont differentes, l'utilisateur voit :

- un popup
- une notification systeme si disponible

## Licence

Ce projet est distribue sous licence proprietaire. Voir le fichier [LICENSE](LICENSE).
