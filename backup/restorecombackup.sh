#!/bin/bash
clear

principal() {
echo "############################################################"
echo "#                                                          #"
echo "#              RESTAURAÇÃO DE BACKUP                       #"
echo "#                                                          #"
echo "############################################################"
echo "Qual o número do ticket de restauração?"
read ticket
echo "Qual o usuário para restauração?"
read usuario
echo
echo  "1) Completa"
echo  "2) Parcial"
echo  "3) Sair"
echo  "Qual o opção desejada?"
read decisao
	case $decisao in
		1) Completa ;;	
		2) Parcial ;;
		3) Sair ;;
 		*)  "Opção Inválida!" ; echo ; principal ;; 	                     
	esac
}
#RESTAURAÇÃO COMPLETA		
			Completa() {
			echo -e "Iniciando a cópia de segurança:"
			mkdir /home/hgtrans/$ticket
                        if [ -d /home/hgtrans/$ticket ]; then
                                /scripts/pkgacct $usuario /home/hgtrans/$ticket;
                                clear
                                echo "O backup foi concluído neste momento, iniciando agora a restauração do NAS"
                                sleep 5
                                /home/hgbackup/restore.pl.old $usuario full;    
                                cd ~$usuario; mv /home/hgtrans/$ticket backup_hg;
                                perms
                                echo -e "A restauração foi finalizada"
                        fi

			}

#RESTAURAÇÃO PARCIAL

Parcial(){
				menu_parcial() {	
				echo -e "1- Banco de dados"
                                echo -e "2- Diretório"
                                echo -e "3- Arquivo"
				echo -e "4- Voltar ao menu inicial"
				echo -e "5- Sair"
				echo  "Qual o opção desejada?"
				read opc_parcial
                                case $opc_parcial in
                                        1) banco ;;
                                        2) diretorio ;;
                                        3) arquivo ;;
					4) menu_inicial ;;
                                        5) sair ;;
					*) "Opção Inválida!" ; echo ; Parcial ;;	
                                esac
			}
				
#BANCO DE DADOS                 
                                banco() {
                                echo -e "Cite o banco de dados que deseja restaurar ou digite 'all' para todos"
                                read restore_banco
                                echo -e "A restauração está sendo iniciada..."
                                if [ restore_banco=all] ; then
                                        /home/hgbackupdir/restore.pl.old $usuario mysql all
                                else
                                        /home/hgbackupdir/restore.pl.old $usuario mysql $restorebanco
                                fi
                                echo -e "A restauração foi finalizada!\n"
                                read -n 1 -p "Pressione qualquer tecla para finalizar!"
                                }


#DIRETÓRIO
                                diretorio() {
                                echo -e "Digite o caminho completo do diretório que deseja restaurar:\n"
                                read restore_diretorio
                                echo -e "A restauração do diretório $restore_diretorio está sendo iniciada..."
                                /home/hgbackupdir/restore.pl.old $usuario directory $restore_diretorio;
                                echo -e "A restauração foi finalizada!\n"
                                read -n 1 -p "Pressione qualquer tecla para finalizar!"
                                }

                                #ARQUIVO
                                arquivo() {
                                echo -e "Digite o caminho completo do arquivo que deseja restaurar:\n"
                                read restore_arquivo
                                echo -e "A restauração do arquivo $restore_arquivo está sendo iniciada..."                      
                                /home/hgbackupdir/restore.pl.old $usuario file $restore_arquivo;
                                echo -e "A restauração foi finalizada!\n"

				}
menu_parcial
				

				}
			

				menu_inicial() {
				principal
				}

				sair()  {
				exit
				}




principal
