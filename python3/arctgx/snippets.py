import re
import vim


variableDeclarationRegex = re.compile(
        r'\s*([\w\\\\]+ )*\$(\w+)(\s*=\s*\w+)*(,*\s)*'
        )
setterLineFormat = r'\n        $this->\2 = $\2;'
docblockParamEntryFormat = r'\n     * @param \1 $\2'

def isAppendingPHPDocblockEnabled():
    return vim.eval("get(g:, 'ultisnips_php_append_docblock', 0)") == "1"


def getDocblockParamEntry(variableDeclaration):
    return re.sub(
            variableDeclarationRegex,
            docblockParamEntryFormat,
            variableDeclaration
            )


def getSetterLine(variableDeclaration):
    return '\n' + re.sub(
            variableDeclarationRegex,
            setterLineFormat,
            variableDeclaration
            )


def wrapByDocblock(text):
    return '/**' + text + '\n     */\n    '


def getEndOfPSR2MultilineArgsList(argsBody):
    if argsBody.find('\n') >= 0:
        return '\n\t) {'
    return ')\n\t{'

def ufcirst(text):
    if len(text) > 0:
        return text[0].upper() + text[1:]
    return ''
