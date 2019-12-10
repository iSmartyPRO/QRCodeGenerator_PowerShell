﻿function New-PSOneQRCodeWifiAccess
{
    <#
            .SYNOPSIS
            Creates a QR code graphic containing a Wifi access

            .DESCRIPTION
            Creates a QR code graphic in png format that - when scanned by a smart device - connects you to a Wifi access point

            .PARAMETER SSID
            The Wifi ssid name

            .PARAMETER Password
            The Wifi access point password

            .PARAMETER Width
            Height and Width of generated graphics (in pixels). Default is 100.

            .PARAMETER Show
            Opens the generated QR code in associated program

            .PARAMETER OutPath
            Path to generated png file. When omitted, a temporary file name is used.

            .EXAMPLE
            New-PSOneQRCodeGeoLocation -SSID InternetCafe -Longitude TopSecret123 -Width 200 -Show -OutPath "$home\Desktop\qr.png"
            Creates a QR code png graphics on your desktop, and opens it with the associated program

            .NOTES
            Compatible with all PowerShell versions including PowerShell 6/Core
            Uses binaries from https://github.com/codebude/QRCoder/wiki

            .LINK
            https://github.com/TobiasPSP/Modules.QRCodeGenerator
    #>

    [CmdletBinding(DefaultParameterSetName="Address")]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $SSID,

        [Parameter(Mandatory)]
        [string]
        $Password,

        [ValidateRange(10,2000)]
        [int]
        $Width = 100,

        [Switch]
        $Show,

        [string]
        $OutPath = "$env:temp\qrcode.png"
    )
        
    $payload = @"
WIFI:S:$SSID;T:WPA2;P:$Password;;
"@

    $generator = New-Object -TypeName QRCoder.QRCodeGenerator
    $data = $generator.CreateQrCode($payload, 'Q')
    $code = new-object -TypeName QRCoder.PngByteQRCode -ArgumentList ($data)
    $byteArray = $code.GetGraphic($Width)
    [System.IO.File]::WriteAllBytes($outPath, $byteArray)

    if ($Show) { Invoke-Item -Path $outPath }
}