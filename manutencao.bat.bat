@echo off
setlocal
color 70
:menu
cls
chcp 65001


echo --------------------------------------------
echo -               Manutenção                 -
echo --------------------------------------------
echo - -1. Realizar Teste                       -
echo - -2. Sair                                 -
echo - -3. Reparar windows (necessario ser adm) -
echo - -4. Redefinir ip                         -
echo - -5. Realizar ping                        -
echo - -6. Redefinir a gpo                      -
echo - -7. Reiniciar o computador               -
echo - -8. Informações sobre o pc               -
echo - -9. Olhar os ciclos de bateria           -
echo - -10. Analisar a tasklist                 -
echo --------------------------------------------
set /p escolha="Escolha uma opçâo (1/2/3/4/5/6/7/8/9/10): " 

if "%escolha%"=="1" (
    call :realizarTeste
) else if "%escolha%"=="2" (
    goto :eof
) else if "%escolha%"=="3" (
    goto :manutencao
)else if "%escolha%"=="4" (
	call :ip
)else if "%escolha%"=="5" (
	call :pin
)else if "%escolha%"=="6" (
	call :gpo
)else if "%escolha%"=="7" (
	call :opp
)else if "%escolha%"=="8" (
	goto :info
)else if "%escolha%"=="9" (
    goto :bateria
)else if "%escolha%"=="10" (
    goto :listatarefas
)else (
    echo Opção inválida. Tente novamente.
    timeout /nobreak /t 2 >nul
    goto :menu
)
:info
hostname
ipconfig /all
timeout /nobreak /t 15 >nul
goto :menu

:eof
echo Saindo do programa...
timeout /nobreak /t 2 >nul
goto :eof

:manutencao 
echo ATENÇÃO, VOCE NÃO PODE DESLIGAR OU INTERROMPER AS AÇÕES A SEGUIR
echo realizando manutenção

echo checando integridade do disco
chkdsk /f 
echo remanejando arquivos em setors defeituosos
chkdsk /r
echo utiliza somente para particoes NTFS,limpa os clusters invalidos do volume
chkdsk /b

REM manutencao de arquivos do pc
sfc /scannow 

timeout /nobreak /t 99999 >nul
timeout /nobreak /t 99999 >nul
timeout /nobreak /t 99999 >nul
timeout /nobreak /t 99999 >nul
timeout /nobreak /t 99999 >nul
timeout /nobreak /t 99999 >nul
timeout /nobreak /t 99999 >nul

:bateria
echo Verificando a saúde da bateria

rem executando a verificação

powercfg /batteryreport
set /p caminho="Digite o caminho especificado pelo comando: "
start "%caminho%"
goto :menu


:realizarTeste
start taskmgr
echo Realizando teste de estresse...

echo determine o nível do teste 40: normal, 80: medio
echo 100: forte, 200: mais forte, 200 +: indeterminado:
set /p num="Determine o nível: "
call :ett

:ett
REM Abrir o arquivo manutencao.bat indefinidas vezes
for /l %%i in (1, 1, %num%) do (
    start manutencao.bat
)


echo Teste iniciado. Aguarde 5 minutos...

REM Esperar 5 minutos
timeout /nobreak /t 300 >nul

echo Fechando todos os processos do teste em 4 minutos...

REM Fechar todos os processos após 4 minutos
timeout /nobreak /t 10 >nul
taskkill /im estresse.bat /f >nul

echo Teste concluído.

timeout /nobreak /t 2 >nul
goto :menu

:ip 
echo configurando release
echo iniciando

ipconfig /release >nul

timeout /nobreak /t 30 >nul

echo configurando renew

ipconfig /renew >nul

timeout /nobreak /t 30 >nul

ipconfig /flushdns

goto :menu

:pin
set /p  relatorio="Deseja exibir um relatório? é necessario executar esse script como administrador (s/n) "
if "%relatorio%"=="s" (
    netsh wlan show wlanreport
    set /p caminho="Escreva o caminho para abrir o reatório "
    start "%caminho%"
    echo
    rem Definindo o endereço IP e o parâmetro do ping
    set /p ipp="Determine o IP (exemplo: 8.8.8.8): "
    set /p pngg="Determine o parâmetro (exemplo: -t ou deixe em branco): "

    rem Realizando o ping
    ping %ipp% -%pngg%

    rem Verificando o código de retorno do ping
    if %errorlevel% neq 0 (
        rem Se o código de retorno for diferente de 0 (sem resposta), muda a cor para vermelho
        color 4
        echo Não houve resposta do IP %ipp%
    ) else (
        rem Se o código de retorno for 0 (resposta recebida), mantém a cor inicial
        color
        echo Resposta recebida do IP %ipp%
    )
)
else (
    rem Definindo o endereço IP e o parâmetro do ping
set /p ipp="Determine o IP (exemplo: 8.8.8.8): "
set /p pngg="Determine o parâmetro (exemplo: -t ou deixe em branco): "

rem Realizando o ping
ping %ipp% -%pngg%

rem Verificando o código de retorno do ping
if %errorlevel% neq 0 (
    rem Se o código de retorno for diferente de 0 (sem resposta), muda a cor para vermelho
    color 4
    echo Não houve resposta do IP %ipp%
) else (
    rem Se o código de retorno for 0 (resposta recebida), mantém a cor inicial
    color
    echo Resposta recebida do IP %ipp%
    
)
)

:gpo
rem Atualizando a gpo
gpupdate /force
timeout /nobreak /t 10 >nul
gpupdate /sync
goto :menu

:opp
echo Reiniciando o computador, para reiniciar digite 1, para forçar o reinicio digite 2, para abortar digite 3.
set /p reinicio="Escolha uma opcao "
if "%reinicio%"=="1" (
	echo Reiniciando a máquina em 10 segundos
	shutdown /r /t 10
    goto :opp
    
) else if "%reinicio%"=="2" (
	echo Forçando o reinicio da máquina
	shutdown /r /t 0
) else (
	echo Abortando o reinicio
	timeout shutdown /a
	goto :menu
)

:listatarefas
echo mostrando tarefas ativas
tasklist 

set /p kll="Digite o PID do processa a ser encerrado "
taskkill /f /pid %kll%

rem Aguarda a pressão de uma tecla para encerrar o script
pause >nul
goto :menu



