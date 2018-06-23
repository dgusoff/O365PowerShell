##ChangeAllPasswords.ps1
# changes the passwords to all accounts in a Microsoft Office Demo "Contoso" environment to a new specified value
# Prerequisite: Azure Active Directory Module for Windows PowerShell
# https://technet.microsoft.com/en-us/library/jj151815.aspx
# https://www.microsoft.com/en-us/download/details.aspx?id=41950
# Derek Gusoff, May 29, 2015

$password = "pass@word1"

$msolcred = get-credential
connect-msolservice -credential $msolcred


Set-MsolUserPassword -UserPrincipalName garthf@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName mollyd@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName alexd@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName allieb@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName annew@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName azizh@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName belindan@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName bonniek@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName brianj@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName davidl@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName denisd@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName dorenap@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName fabricec@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName garretv@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName janets@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName juliani@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName robinc@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName roby@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName sarad@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName tonyk@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName zrinkam@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
Set-MsolUserPassword -UserPrincipalName admin@mytenant.onmicrosoft.com -NewPassword $password -ForceChangePassword $false
