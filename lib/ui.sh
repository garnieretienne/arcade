readonly NO_COLOR='\e[0m'
readonly LIGTH_RED='\e[91m'
readonly LIGTH_CYAN='\e[96m'
readonly LIGTH_GREY='\e[37m'

# Indent text as a topic
topic() {
  while read text; do
    echo -e "${LIGTH_CYAN}>> ${text}${NO_COLOR}"
  done
}

# Indent text as info
info() {
  while read text; do
    echo -e "${LIGTH_GREY}   ${text}${NO_COLOR}"
  done
}

# Indent text as warning
warning() {
  while read text; do
    echo -e "${LIGTH_RED} ! ${text}${NO_COLOR}" 1>&2
  done
}
