#!/bin/bash

declare -A products=(
  ["яблуко"]=10
  ["грушка"]=15
  ["апельсин"]=20
  ["морозиво"]=30
  ["цукерки"]=5
  ["ананас"]=25
  ["манго"]=35
  ["киві"]=12
  ["шоколад"]=18
  ["печиво"]=7
)

declare -A cart
total=0

function show_menu {
  echo "=================================="
  echo "           МЕНЮ МАГАЗИНУ          "
  echo "=================================="
  for item in "${!products[@]}"; do
    printf "%-10s %-10s грн\n" "$item:" "${products[$item]}"
  done
  echo "=================================="
}

function add_to_cart {
  product=$1
  quantity=$2
  if [[ -z $product ]] || [[ -z $quantity ]]; then
    echo "Помилка: Будь ласка, введіть коректну назву товару та кількість."
    sleep 3
    return 1
  fi
  if [[ ${products[$product]+abc} ]]; then
    if [[ $quantity =~ ^[0-9]+$ ]]; then
      if [[ ${cart[$product]+abc} ]]; then
        ((cart[$product]+=quantity))
      else
        cart[$product]=$quantity
      fi
      ((total+=${products[$product]}*$quantity))
      echo "$quantity x $product додано до кошика."
    else
      echo "Помилка: Введіть коректну кількість товару."
      sleep 3
      return 1
    fi
  else
    echo "Помилка: Невірна назва товару."
    sleep 3
    return 1
  fi
}

function show_cart {
  if [ ${#cart[@]} -eq 0 ]; then
    echo "Кошик порожній."
  else
    echo "=================================="
    echo "               КОШИК              "
    echo "=================================="
    for item in "${!cart[@]}"; do
      printf "%-10s %-10s шт %-10s грн\n" "$item:" "${cart[$item]}" "$((${cart[$item]}*${products[$item]}))"
    done
    echo "=================================="
    printf "Загальна сума: %-10s грн\n" "$total"
  fi
}

while true; do
  clear
  show_menu
  show_cart
  echo "Введіть назву товару та кількість (наприклад, яблуко 3) або просто напишіть 'в' щоб вийти:"
  read input
  if [ "$input" == "в" ]; then
    break
  else
    add_to_cart $input
  fi
done
echo "Зачекайте будь ласка оформлюється чек..."
sleep 2
clear
echo "
====================================
		ЧЕК
====================================

"
show_cart
echo "Дякуємо за покупки!"

