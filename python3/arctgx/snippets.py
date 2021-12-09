import re
import vim


variableDeclarationRegex = re.compile(
        r'\s*([\w\\\\]+ )*\$(\w+)(\s*=\s*\w+)*(,*\s)*'
        )
setterLineFormat = r'\n        $this->\2 = $\2;'

def getSetterLine(variableDeclaration):
    return '\n' + re.sub(
            variableDeclarationRegex,
            setterLineFormat,
            variableDeclaration
            )

def getEndOfPSR2MultilineArgsList(argsBody):
    return '\n) {'

def ufcirst(text):
    if len(text) > 0:
        return text[0].upper() + text[1:]
    return ''
