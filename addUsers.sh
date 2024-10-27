#!/bin/bash

# Seul cas où on sort du script : pas d'arguments
if [ $# -eq 0 ]; then
    echo "Il manque les noms d'utilisateurs en argument - Fin du script"
    exit 1
fi

while true; do
    for username in "$@"; do
        if dscl . -read /Users/$username &>/dev/null; then
            echo "L'utilisateur '$username' existe déjà"
            continue
        fi
        
        if sudo dscl . -create /Users/$username &>/dev/null; then
            echo "L'utilisateur '$username' a été créé"
        else
            echo "Erreur à la création de l'utilisateur '$username'"
        fi
    done

    read -p "Pour créer d'autres utilisateurs, tapez 'A', pour quitter tapez 'q' : " reponse

    if [ "$reponse" = "q" ]; then
        exit 0
    elif [ "$reponse" = "A" ]; then
        read -p "Entrez les noms des nouveaux utilisateurs : " -a nouveaux_users
        if [ ${#nouveaux_users[@]} -eq 0 ]; then
            echo "Il manque les noms d'utilisateurs en argument - Fin du script"
            exit 1
        fi
        set -- "${nouveaux_users[@]}"
    fi
done
