#!/usr/bin/python3

import sys
import datetime

template = """tags: 

## Todo

- [ ] Verificar lista de projetos
- [ ] Treino Live Code

## Notas

"""

date = (datetime.date.today() if len(sys.argv) < 2
        else sys.argv[1].rsplit(".", 1)[0].rsplit("/", 1)[1])

print(template.format(date=date))
