NAME	=	inception
D		=	docker
DIR		=	./srcs/
CHDIR	=	cd

all: $(NAME)

$(NAME):
	@$(CHDIR) $(DIR) && $(D) compose up -d

clean:
	@$(CHDIR) $(DIR) && $(D) compose down

fclean: clean
	@$(D) rm $(shell docker ps -aq) 2> /dev/null || echo ""
	@$(D) rmi $(shell docker images -aq) 2> /dev/null || echo ""

re: fclean all
