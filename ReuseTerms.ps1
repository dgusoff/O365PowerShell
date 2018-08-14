# ReuseTerms
# Derek Gusoff. https://github.com/dgusoff
# shows how to reuse a term and/or reuse with pinning

if($cred -eq $null){
 $cred = Get-Credential
}

Connect-PnPOnline https://xxxxx.sharepoint.com/sites/home


$pinnedTerm = Get-PnPTaxonomyItem -TermPath "Conglomo|Departments|Research and Development"
$sourceTermSet = Get-PnPTaxonomyItem -TermPath "Conglomo|Sitemap|Department Sites"

# option 1: reuse
$sourceTermSet.ReuseTerm($pinnedTerm, $true)

# option 2: reuse with pinning
$sourceTermSet.ReuseTermWithPinning($pinnedTerm)

(Get-PnPContext).Load($pinnedTerm)
Invoke-PnPQuery
