#!/bin/bash

# Define products and prices
declare -A products=(
    [1]="Laptops"
    [2]="Smartphones"
    [3]="Televisions"
    [4]="Headphones"
    [5]="Speakers"
)

declare -A prices=(
    ["Laptops"]="500 2000"
    ["Smartphones"]="300 800"
    ["Televisions"]="200 1500"
    ["Headphones"]="50 200"
    ["Speakers"]="100 500"
)

# Function to greet the customer
greet_customer() {
    local greetings=("Hello, welcome to Electronics Direct!" "Hi there! How can I help you today?" "Good day! Are you looking for something specific?")
    echo "${greetings[$(expr $RANDOM % ${#greetings[@]})]}"
}

# Function to display products
browse_products() {
    echo "We offer a wide range of electronics:"
    for key in $(echo "${!products[@]}" | tr ' ' '\n' | sort -n); do
        product=${products[$key]}
        price=$(echo "${prices[$product]}" | awk '{print int($1 + rand() * ($2 - $1 + 1))}')
        echo "$key. $product (Price: \$$price)"
    done
}


# Function to select products
select_products() {
    selected_products=()
    while true; do
        read -p "Enter the product number you would like to purchase (or type 'done' to finish): " choice
        case $choice in
            [1-5])
                selected_products+=(${products[$choice]})
            ;;
            "done")
                break
            ;;
            *)
                echo "Invalid choice. Please choose a valid product number or type 'done' to finish."
            ;;
        esac
    done
}

# Function for checkout
checkout() {
    if [ ${#selected_products[@]} -eq 0 ]; then
        echo "No products selected. Thanks for browsing!"
        return
    fi
    echo "-------------------------------"
    echo "** Electronics Store - Receipt**"
    total_price=0
    for product in "${selected_products[@]}"; do
        price=$(echo "${prices[$product]}" | awk '{print int($1 + rand() * ($2 - $1 + 1))}')
        echo "Product: $product (Price: \$$price)"
        (( total_price += price ))
    done
    echo "-------------------------------"
    echo "Total Price: \$$total_price"
    read -p "How would you like to pay? (cash/credit): " payment_method
    payment_method=$(echo "$payment_method" | tr '[:upper:]' '[:lower:]')
    if [ "$payment_method" == "cash" ] || [ "$payment_method" == "credit" ]; then
        echo "Thank you for your purchase! Your $payment_method payment has been processed."
    else
        echo "Invalid payment method. Please choose cash or credit."
    fi
}

# Main function
main() {
    greet_customer
    browse_products
    select_products
    checkout
}

# Run main function
main
