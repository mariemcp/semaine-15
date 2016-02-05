class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # méthode pour renvoyer le nom et les points de vie si la personne est en vie sinon renvoie le nom et "vaincu"
    if @en_vie
      @nom + " ( #{points_de_vie}/100 Points de vie )"
    else
      @nom + "\033[31m (** Dommage! Tu es vaincu !**)\33[0m"
    end
  end

  def attaque(personne)
    # Méthode pour faire subir des dégâts à la personne passée en paramètre et affiche ce qu'il s'est passé
    puts "#{@nom} attaque #{personne.nom} "
	puts " "
	puts "****************************************"
	puts " "
    personne.subit_attaque(degats)
  end

  def subit_attaque(degats_recus)
    # méthode pour réduire les points de vie en fonction des dégâts reçus et affiche ce qu'il s'est passé, 
    # puis détermine si la personne est toujours en vie ou non
	puts "#{@nom} subit #{degats_recus} points de dégats !!!"
	puts " "
	puts "*****************************************"
	puts " "
    @points_de_vie -= degats_recus

    if @points_de_vie <= 0 && @en_vie
       @en_vie = false
       puts "\033[31m#{@nom} a été vaincu\033[0m"
    end
  end
end



class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    # Méthode pour calculer les dégats et afficher ce qu'il s'est passé
    puts "#{@nom} gagne #{@degats_bonus} points de dégats bonus"
	puts " "
	@degats_bonus + 5
  end

  def soin
    # Méthode pour gagner de la vie et afficher ce qu'il s'est passé
    @points_de_vie += 20
	puts "...................................................................."
    puts "\033[032m\n#{@nom} regagne de la vie.\n\n\033[0m"
	puts "  "
  end


  def ameliorer_degats
    # Méthode pour augmenter les dégâts bonus et afficher ce qu'il s'est passé
    @degats_bonus += 20
	puts " "
    puts "\033[32m\n#{@nom} gagne de l'énergie et #{@degats_bonus} points de dégats bonus!!!\033[0m"
	puts " "
	puts "...................................................................."
	puts " "
  end
  
end



class Ennemi < Personne
  def degats
    # Méthode pour calculer les dégâts
   +5
  end
end



class Jeu
  def self.actions_possibles(monde)
    puts "            VOICI LES ACTIONS POSSIBLES :"
	puts " "

    puts "\033[32m 0 - Se soigner\033[0m"
    puts "\033[32m 1 - Améliorer son attaque\033[0m"

    # On commence à 2 car 0 et 1 sont réservés pour les actions de soins et d'amélioration d'attaque
    
    i = 2
    monde.ennemis.each do |ennemi|
      puts "\033[31m #{i} - Attaquer \033[0m #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    # Méthode pour déterminer la condition de fin de jeu
	
    if !joueur.en_vie || monde.ennemis_en_vie.size == 0
      true
    else
      false
	end
  end
end



class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    # Méthode pour ne retourner que les ennemis en vie
  @ennemis.select do |ennemi|
      ennemi.en_vie
    end
  end
end



##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("\033[36m Balrog \033[0m"),
  Ennemi.new("\033[33m Goblin \033[0m"),
  Ennemi.new("\033[35m Squelette \033[0m")
]

# Initialisation du joueur
joueur = Joueur.new("\033[32mJean-Michel Paladin\033[0m")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\n\                 Ainsi commencent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principal
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nCHOISISSEZ UNE ACTION "
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi 99 qui veut dire "quitter"
    break
  else
    # Sinon choix  à partir de 2, puisque  0 concerne le soin et 1 l'amélioration d'attaque
   
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\033[34m\nEtat du héros: \033[0m" + " #{joueur.info}\n"

  # Quand le jeu est fini, on interrompt la boucle
  break if Jeu.est_fini(joueur, monde)
end
puts " "
puts "\Le jeu est fini!\n"


# On affiche le résultat de la partie

if joueur.en_vie
  puts "\033[32mBravo! Vous avez gagné contre tous !\33[0m"
  puts " "
else
  puts "\033[31mVous avez perdu! Ils ont été plus forts que vous!\033[0m"
  puts " "
end



# Bilan de la partie

puts "#{joueur.nom}" + if joueur.en_vie; " a encore #{joueur.points_de_vie} points de vie." else; " a été vaincu!" end
puts  "" + if joueur.degats_bonus > 0; "Il a augmenté ses dégats bonus de #{joueur.degats_bonus} points" else; "Il n'a pas augmenté ses dégats bonus" end + " lors de cette partie.\n\n"

monde.ennemis.each do |ennemi|
	puts "#{ennemi.nom}" + if ennemi.en_vie; " a encore #{ennemi.points_de_vie} points de vie." else; " a été vaincu!" end
end