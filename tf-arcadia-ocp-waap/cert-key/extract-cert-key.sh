#!/bin/sh
openssl pkcs12 -info -in f5-apac-sp.console.ves.volterra.io.api-creds.p12 -out private_key.key -nodes -nocerts
openssl pkcs12 -info -in f5-apac-sp.console.ves.volterra.io.api-creds.p12 -out certificate.cert -nokeys
