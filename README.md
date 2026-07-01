# VitaeX - Pasaporte Académico UAI en Blockchain - Grupo 9

## Descripción

VitaeX es una prueba de concepto de un pasaporte académico digital en blockchain para la Universidad Adolfo Ibáñez. El sistema permite emitir, visualizar, verificar y revocar credenciales académicas asociadas a la wallet de un estudiante.

El objetivo del proyecto es reducir la dependencia de certificados en PDF, correos electrónicos o procesos manuales de verificación, permitiendo que los logros académicos puedan ser comprobados directamente en blockchain.

## Archivos del repositorio

```text
contracts/
  PasaporteAcademico.sol

frontend/
  index.html
```

## Contrato inteligente

El contrato `PasaporteAcademico.sol` implementa credenciales académicas como tokens ERC-721 soulbound, es decir, no transferibles. Solo la cuenta owner, que representa a la institución emisora, puede emitir y revocar logros.

El contrato permite almacenar la información principal de cada logro académico, asociarlo a una wallet de estudiante y consultar públicamente las credenciales activas de una dirección.

### Funciones principales

- `emitirLogro`: emite una credencial académica a una wallet de estudiante.
- `tokensDe`: consulta los logros asociados a una wallet.
- `tokenURI`: entrega los metadatos e imagen SVG generados on-chain.
- `revocarLogro`: revoca una credencial emitida.
- `totalEmitidos`: muestra el total de credenciales emitidas.
- `nombreEstudiante`: permite consultar el nombre asociado a una wallet.

## Frontend

El archivo `frontend/index.html` contiene la interfaz web del prototipo. Permite conectar MetaMask, verificar la red Sepolia, emitir logros desde la cuenta owner, consultar pasaportes académicos y revocar credenciales.

La interfaz diferencia entre dos tipos de usuario:

- Institución emisora: puede emitir y revocar logros.
- Estudiante o verificador: puede consultar credenciales propias o de otra dirección.

## Tipos de credenciales del prototipo

Para la prueba de concepto se consideraron tres tipos de logros académicos:

- Título universitario.
- Aprobación de curso.
- Ayudantía.

## Características principales

- Credenciales académicas verificables en blockchain.
- Tokens ERC-721 soulbound, no transferibles.
- Emisión restringida a la cuenta owner.
- Revocación de credenciales en caso de error o necesidad administrativa.
- Metadatos e imagen SVG generados directamente on-chain.
- Consulta pública de logros asociados a una wallet.
- Frontend conectado con MetaMask y la red Sepolia.

## Tecnologías utilizadas

- Solidity
- ERC-721
- OpenZeppelin
- Sepolia
- MetaMask
- HTML
- JavaScript
- ethers.js

## Red utilizada

El prototipo fue desplegado y probado en la red Sepolia, una red de prueba de Ethereum. Esta red permite ejecutar transacciones y validar el funcionamiento del sistema sin utilizar dinero real.

## Uso básico

1. Abrir el archivo `frontend/index.html` en el navegador.
2. Conectar MetaMask.
3. Verificar que MetaMask esté usando la red Sepolia.
4. Si la wallet conectada corresponde al owner, se habilitan las funciones de emisión y revocación.
5. Si la wallet conectada no corresponde al owner, se habilita la vista de estudiante o verificador.
6. Consultar los logros asociados a una dirección de wallet.

## Nota

Este proyecto fue desarrollado como prueba de concepto académica para el curso de Blockchain. No corresponde a una implementación lista para producción, ya que aún requiere mejoras en privacidad, recuperación de wallet, costos de gas y gestión de múltiples instituciones emisoras.
