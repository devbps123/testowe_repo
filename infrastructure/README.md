# infrastructure
NIe dodaje swojego klucza Mozna sobie wygenerowac swoj i podmienic wartosc "credentials" w 
infrastructure/environments/dev/dev.tfvars
#github
przed rozpoczeciem pracy z tym modulem nalezy wyexportowac dwie zmienne srodowiskowe
TF_VAR_GITHUB_TOKEN=tutaj nalezy wkleic token wygenerowany przez strone Settings->Developer Settings ->Personal Access Token -> Tokens(classic)
TF_VAR_GITHUB_OWNER=devbps123