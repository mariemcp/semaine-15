puts " "
puts ("\033[31m Jeu du plus ou moins\033[0m.".center(80))
puts " "
puts ("L'ordinateur choisit un nombre entre 1 et 100.".center(80))
puts ("\033[32mA vous de le deviner!\033[0m".center(80))
puts " "
puts " "


coups = 0
ordinateur  = rand(99) + 1


nombre = -1

while ordinateur != nombre

    puts "Choisissez à votre tour un nombre compris entre 1 et 100 : "
    nombre = gets.chomp
    nombre = nombre.to_i
    coups   += 1 
  
    if (nombre < ordinateur)
        puts "\033[33m#{nombre} est trop petit ! Essayez encore ! \033[0m"
		puts " "
    end
	
    if (nombre > ordinateur)
        puts "\033[31m#{nombre} est trop grand ! Essayez encore! \033[0m"
		puts " "
    end
    
    if (nombre == ordinateur)
        puts "\033[32mBravo ! Vous avez trouvé après #{coups} coup(s).\033[0m"  
    end
end  

