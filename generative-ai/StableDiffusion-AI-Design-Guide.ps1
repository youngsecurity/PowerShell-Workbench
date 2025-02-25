# This PowerShell script writes a string from a series of variables. 
# The output is expected to be used with generative AI content creation solutions.
# The variables and output prompt I'm using here are for using Stable Diffusion.

# Declare variables

$who = "zero suit samus in the metroid spaceship hovercraft"  # Who is the main and/or supporting character(s)?
$what = "slowly descends to land on" # What is the main character doing, and/or how do the supporting characters help?
$where = "rocky rainy windy planet zebes with craters, mountains, caves" # Where is the primary location(s), secondary, tertiary, etc.
$when = "at night" # When does this event occur in time?
$why= "to eradicate lifeform deep inside planet cavernous base" # What is the purpose?

try {
    Write-Host "$who $what $where $when $why."
}
catch {
    Write-Host "An Error Occurred" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {    
    $Error.Clear()
}
