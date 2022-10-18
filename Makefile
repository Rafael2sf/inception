NAME	=	inception
D		=	docker
DIR		=	./srcs/
CHDIR	=	cd

all: start

$(NAME): start

start:
	@$(CHDIR) $(DIR) && $(D) compose up -d

stop:
	@$(CHDIR) $(DIR) && $(D) compose stop

clean:
	@$(CHDIR) $(DIR) && $(D) compose down

rclean:
	@$(CHDIR) $(DIR) && $(D) compose down --rmi all

fclean:
	@$(CHDIR) $(DIR) && $(D) compose down --volumes --rmi all

re: fclean all

.PHONY: all start stop clean rclean fclean re
