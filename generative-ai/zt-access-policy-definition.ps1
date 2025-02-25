# This PowerShell script writes a string from a series of variables. 
#
# The output is expected to be used with generative AI content creation solutions.
# The variables and output prompt I'm using here are for creating Zero Trust 
# access policies.
#
# In Zero Trust we deny by default, use least priviledges, and monitor continuously. 
# - We identify why we allow traffic, because we deny traffic by default. 

# A label strategy is necessary to create consistent rules

# R - Role
# E - Environment
# A - Application
# L - Location

# Example: L-FL,E-DEV,A-WEB,R-USER

# Declare variables

$who = ""  # Who is the Source User or Entity?
$what = "" # What packets for which application?
$where = "" # What is the destination?
$when = "" # When is the traffic allowed?
$why= "" # What is the purpose of the allowed traffic?
$how= "" # How is the connection made

try {
    Write-Host "$who $what $where $when $why $how."
}
catch {
    Write-Host "An Error Occurred" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {    
    $Error.Clear()
}
