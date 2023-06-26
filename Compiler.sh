#!/bin/bash

# Function to check if a package is installed
package_installed() {
    if dpkg -s "$1" >/dev/null 2>&1; then
        return 0  # Package is installed
    else
        return 1  # Package is not installed
    fi
}

# Function to display an ASCII banner
display_banner() {
    clear
    echo "
 █████╗ ██╗   ██╗ ██████╗ ██████╗ ██████╗ ██╗   ██╗
██╔══██╗██║   ██║██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
███████║██║   ██║██║   ██║██████╔╝██████╔╝ ╚████╔╝ 
██╔══██║██║   ██║██║   ██║██╔══██╗██╔═══╝   ╚██╔╝  
██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║        ██║   
╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝        ╚═╝   
                                                  
    Compiler Script
"
}

# Check if required packages are installed and install if necessary
required_packages=("clang" "g++" "gcc" "mono")

display_banner

for package in "${required_packages[@]}"; do
    if package_installed "$package"; then
        echo "$package is already installed."
    else
        echo "$package is not installed."
        read -p "Do you want to install $package? (y/n): " choice
        if [ "$choice" = "y" ]; then
            display_banner
            echo "Installing $package..."
            pkg install -y "$package"
            echo "Installation of $package completed."
        fi
    fi
done

display_banner

# Prompt for user input
echo "Select an option:"
echo " [1] \e[32mCompile\e[0m"  # Compile option displayed in green
echo " [2] \e[31mDecompile\e[0m"  # Decompile option displayed in red
read -p "Enter your choice: " option

if [ "$option" = "1" ]; then
    read -p "Enter the file path to compile: " source_file
    read -p "Enter the desired output file name: " output_file

    # Compilation
    echo "Compiling..."
    if [[ $source_file == *.cpp ]]; then
        g++ -o "$output_file" "$source_file"
    elif [[ $source_file == *.c ]]; then
        gcc -o "$output_file" "$source_file"
    elif [[ $source_file == *.cs ]]; then
        mcs -out:"$output_file" "$source_file"
    else
        echo "Unsupported file extension."
        exit 1
    fi

    # Check if the compilation was successful
    if [ $? -eq 0 ]; then
        echo "Compilation successful."
    else
        echo "Compilation failed."
        exit 1
    fi

elif [ "$option" = "2" ]; then
    read -p "Enter the file path to decompile: " source_file

    # Decompilation
    echo "Decompiling..."
    if [[ $source_file == *.cpp ]] || [[ $source_file == *.c ]]; then
        objdump -d "$source_file" > "$source_file.asm"
        echo "Decompilation completed. Assembly code saved to $source_file.asm"
    elif [[ $source_file == *.cs ]]; then
        echo "Decompilation for C# is not supported."
    else
        echo "Unsupported file extension."
        exit 1
    fi

else
    echo "Invalid option selected."
    exit 1
fi
