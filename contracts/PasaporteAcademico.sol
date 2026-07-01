// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract PasaporteAcademico is ERC721, Ownable {
    using Strings for uint256;

    struct Logro {
        string tipo;
        string titulo;
        uint256 fecha;
        address emisor;
    }

    uint256 private _nextId;
    mapping(uint256 => Logro) public logros;
    mapping(address => uint256[]) private _pasaporte;
    mapping(address => string) public nombreEstudiante;

    event LogroEmitido(address indexed estudiante, uint256 indexed tokenId, string tipo, string titulo);
    event LogroRevocado(address indexed estudiante, uint256 indexed tokenId);

    constructor() ERC721("Pasaporte Academico UAI", "UAICRED") Ownable(msg.sender) {}

    function emitirLogro(
        address estudiante,
        string memory nombre,
        string memory tipo,
        string memory titulo
    ) external onlyOwner returns (uint256) {
        bytes memory actual = bytes(nombreEstudiante[estudiante]);
        if (actual.length == 0) {
            require(bytes(nombre).length > 0, "Indica el nombre del estudiante");
            nombreEstudiante[estudiante] = nombre;
        } else {
            require(
                bytes(nombre).length == 0 || keccak256(bytes(nombre)) == keccak256(actual),
                "Esta wallet ya esta asociada a otra persona"
            );
        }

        uint256 tokenId = _nextId++;
        _safeMint(estudiante, tokenId);
        logros[tokenId] = Logro(tipo, titulo, block.timestamp, msg.sender);
        _pasaporte[estudiante].push(tokenId);
        emit LogroEmitido(estudiante, tokenId, tipo, titulo);
        return tokenId;
    }

    // 2. CONSULTA
    function tokensDe(address estudiante) external view returns (uint256[] memory) {
        return _pasaporte[estudiante];
    }

    function totalEmitidos() external view returns (uint256) {
        return _nextId;
    }

    // 3. REVOCAR (solo la UAI)
    function revocarLogro(uint256 tokenId) external onlyOwner {
        address estudiante = _requireOwned(tokenId);
        _burn(tokenId);
        delete logros[tokenId];
        uint256[] storage lista = _pasaporte[estudiante];
        for (uint256 i = 0; i < lista.length; i++) {
            if (lista[i] == tokenId) {
                lista[i] = lista[lista.length - 1];
                lista.pop();
                break;
            }
        }
        emit LogroRevocado(estudiante, tokenId);
    }

    // 4. SOULBOUND
    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        if (from != address(0) && to != address(0)) {
            revert("Soulbound: el logro no se puede transferir");
        }
        return super._update(to, tokenId, auth);
    }

    function approve(address, uint256) public pure override {
        revert("Soulbound: no se permite approve");
    }

    function setApprovalForAll(address, bool) public pure override {
        revert("Soulbound: no se permite setApprovalForAll");
    }

    // 5. METADATOS + IMAGEN ON-CHAIN
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        Logro memory l = logros[tokenId];
        string memory image = Base64.encode(bytes(_svg(l)));
        string memory json = string.concat(
            '{"name":"', l.titulo,
            '","description":"Logro academico emitido por la UAI (soulbound).",',
            '"attributes":[',
                '{"trait_type":"Tipo","value":"', l.tipo, '"},',
                '{"trait_type":"Fecha","value":"', l.fecha.toString(), '"}',
            '],"image":"data:image/svg+xml;base64,', image, '"}'
        );
        return string.concat("data:application/json;base64,", Base64.encode(bytes(json)));
    }

    function _svg(Logro memory l) internal pure returns (string memory) {
        string memory color = _colorPorTipo(l.tipo);
        return string.concat(
            '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="#0d1117"/>',
            '<polygon points="200,40 330,115 330,285 200,360 70,285 70,115" ',
            'fill="none" stroke="', color, '" stroke-width="6"/>',
            '<text x="200" y="150" font-family="sans-serif" font-size="22" ',
            'fill="', color, '" text-anchor="middle">UAI</text>',
            '<text x="200" y="205" font-family="sans-serif" font-size="17" ',
            'fill="#ffffff" text-anchor="middle">', l.tipo, '</text>',
            '<text x="200" y="245" font-family="sans-serif" font-size="13" ',
            'fill="#c9d1d9" text-anchor="middle">', l.titulo, '</text>',
            '</svg>'
        );
    }

    function _colorPorTipo(string memory tipo) internal pure returns (string memory) {
        bytes32 h = keccak256(bytes(tipo));
        if (h == keccak256(bytes("Titulo")))    return "#f0b429";
        if (h == keccak256(bytes("Curso")))     return "#3aa0ff";
        if (h == keccak256(bytes("Ayudantia"))) return "#2dd4a8";
        return "#a0a0a0";
    }
}