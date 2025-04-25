.PHONY: *

SHELL := /bin/bash
DIR := ${CURDIR}

vscodePhpDebugVersion := '1.36.1'
vscodePhpDebugUrl := 'https://github.com/xdebug/vscode-php-debug/releases/download/v1.36.1/php-debug-1.36.1.vsix'
bashDebugVersion := '0.3.9'
bashDebugUrl := 'https://github.com/rogalmic/vscode-bash-debug/releases/download/untagged-438733f35feb8659d939/bash-debug-0.3.9.vsix'
cpptoolsVersion := '1.18.0'
cpptoolsUrl := 'https://github.com/microsoft/vscode-cpptools/releases/download/v1.18.0/cpptools-linux.vsix'

.ONESHELL:
install-vscode-php-debug:
	set -e
	$(DIR)/bin/dap-adapter-utils install xdebug vscode-php-debug $(vscodePhpDebugVersion) $(vscodePhpDebugUrl)
	$(DIR)/bin/dap-adapter-utils setAsCurrent vscode-php-debug $(vscodePhpDebugVersion)

.ONESHELL:
install-vscode-bash-debug:
	set -e
	$(DIR)/bin/dap-adapter-utils install rogalmic vscode-bash-debug $(bashDebugVersion) $(bashDebugUrl)
	$(DIR)/bin/dap-adapter-utils setAsCurrent vscode-bash-debug $(bashDebugVersion)

.ONESHELL:
install-vscode-cpptools-debug:
	set -e
	$(DIR)/bin/dap-adapter-utils install microsoft vscode-cpptools $(cpptoolsVersion) $(cpptoolsUrl)
	$(DIR)/bin/dap-adapter-utils setAsCurrent vscode-cpptools $(cpptoolsVersion)

require-init:
ifndef nvimInit
	$(error nvimInit path is required)
else
	@echo > /dev/null
endif

projectDir := $(DIR)
.ONESHELL:
luarc: require-init
	cd $(projectDir)
	$(DIR)/bin/luarc-generator $(nvimInit)

start: install-vscode-php-debug
