# Mars Rover Kata

_Ce kata est l'adaptation du kata du même nom sur le site de [kata-log.rocks][kata-log]._

## Contexte

Vous faite partie de l'équipe chargée d'explorer Mars. Vous y avez envoyé un robot qui attends vos
instructions. Le but est de déplacer le robot et de cartographier l'environnement. Le robot identifie
sa position de manière unique en utilisant une direction un marqueur. Chaque position possède un
marqueur unique.

## Communication avec le Robot

Le robot est accessible via TCP. Voici un exemple d'échange commenté d'échange entre vous, depuis le
centre de controle, et le robot:

```
# À la connection, le robot envoi sa position et son orientation
> afd2a7 N

# On lui envoie une commande
< ffr

# Il répond en donnant la suite de commandes qu'il a exécuté, le marqueur de position et son orientation
> ffr d412b5 E

< ffr
> ffr 3ac942 S

< ffr
> ffr 4ba28f W

# On revient sur une cellule déjà connue, le marqueur de position est identique
< ffl
> ffl afd2a7 S

# Lorsqu'un obstacle est présent, le robot s'arrête en cours de commande
> fffl
< ff d73cf2 S
```

* Les directions sont les suivantes : `N`, `S`, `E` et `W`.
* Les commandes sont sur une ligne terminées par un `\n`.
* Les commandes sont : `f`, `b`, `l` et `r` pour respectivement avancer, reculer, tourner de 90° vers la droite et tourner de 90° vers la gauche.
* La planète est sphérique, en allant toujours dans la même direction, on peut revenir à la même position (s'il n'y a pas d'obstacle).

## Vos objectifs

0. Se connecter au robot à l'adresse donnée au début du kata
1. Explorer aléatoirement Mars
2. Construire une représentation de la plannète où figurent les obstacles
3. Afficher cette représentation à l'écran en temps réel


[kata-log]: http://kata-log.rocks/mars-rover-kata
