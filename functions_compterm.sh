function is_parent_compterm {
    local pid=$$
    local parent_pid

    while [ "$pid" -ne 1 ]; do
        parent_pid=$(ps -p $pid -o ppid=)
        parent_pid=${parent_pid//[[:blank:]]/}  # Remove espaços

        # Verifica se o nome do comando do processo pai é 'compterm'
        if ps -p $parent_pid -o comm= | grep -q "^compterm$"; then
            return 0  # Retorna true se encontrar 'compterm'
        fi

        pid=$parent_pid
    done

    return 1  # Retorna false se 'compterm' não for encontrado
}

