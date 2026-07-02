# VitaeX - Pasaporte Académico UAI en Blockchain - Grupo 9

Integrantes: Ignacia Marambio, Diego Kusanovic, Tomás Sánchez y Claudia Herrera 

Dirección contrato desplegado: 0xc1092A2fED2e846CF52ed3d6038d12A8C0F95684

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

## Frontend

El archivo `frontend/index.html` contiene la interfaz web del prototipo. Permite conectar MetaMask, verificar la red Sepolia, emitir logros desde la cuenta owner, consultar pasaportes académicos y revocar credenciales.

La interfaz diferencia entre dos tipos de usuario:

- Institución emisora: puede emitir y revocar logros.
- Estudiante o verificador: puede consultar credenciales propias o de otra dirección.

## Uso básico

1. Abrir el archivo `frontend/index.html` en el navegador.
2. Conectar MetaMask.
3. Verificar que MetaMask esté usando la red Sepolia.
4. Si la wallet conectada corresponde al owner, se habilitan las funciones de emisión y revocación.
5. Si la wallet conectada no corresponde al owner, se habilita la vista de estudiante o verificador.
6. Consultar los logros asociados a una dirección de wallet.
