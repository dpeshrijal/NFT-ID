//SPDX-License-Identifier:MIT

pragma solidity 0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/Base64.sol";

contract IdNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    string nameSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 6.46216 4.31765' > <defs > <style type='text/css' > .str1 {stroke:#1F1A17;stroke-width:0.0286362} .str0 {stroke:white;stroke-width:0.0286362} .fil2 {fill:#1F1A17} .fil0 {fill:#EAE342} .fil1 {fill:white} </style > </defs > <g id='Ebene_x0020_1' > <g id='_161378960' > <rect class='fil0 str0' rx='.55944' ry='.55944' height='4.28' width='6.4335' y='.014318' x='.014318' /> <rect class='fil1 str0' rx='.18648' ry='.18648' height='2.8324' width='2.4219' y='.38195' x='.36631' /> <g > <circle cy='1.2031' cx='1.5994' r='.67599' class='fil2 str1' /> <path id='_161099336' d='m0.50382 3.2311h2.1678v-0.54778c0-0.30128-0.2465-0.54778-0.54778-0.54778h-1.0722c-0.30128 0-0.54778 0.2465-0.54778 0.54778v0.54778z' class='fil2 str1' /> </g > <rect class='fil1 str0' rx='.13986' ry='.13986' height='.27972' width='2.806' y='.88526' x='3.3055' /> <text x='4.71' y='1.08' font-size='1%' text-anchor='middle' >";
    string dateSvg =
        "<rect id='_161099096' class='fil1 str0' rx='.13986' ry='.13986' height='.27972' width='2.806' y='1.6011' x='3.3055' /> <text x='4.71' y='1.8' font-size='1%' text-anchor='middle'>";
    string emailSvg =
        "<rect id='_161099168' class='fil1 str0' rx='.13986' ry='.13986' height='.27972' width='2.806' y='2.3171' x='3.3055' /> <text x='4.71' y='2.5' font-size='1%' text-anchor='middle' >";
    string idSvg =
        "<text x='5' y='3.9' font-size='2%' text-anchor='middle' >ID#</text> <text x='5.8' y='3.909' font-size='2%' text-anchor='middle' >";

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("IdNFT", "ID") {
        console.log("This Contract Creates your NFT ID!");
    }

    function fullName(string memory _fullName)
        public
        view
        returns (string memory)
    {
        return string(abi.encodePacked(nameSvg, _fullName, "</text>"));
    }

    function dateOfCreation(string memory _date)
        public
        view
        returns (string memory)
    {
        return string(abi.encodePacked(dateSvg, _date, "</text>"));
    }

    function email(string memory _email) public view returns (string memory) {
        return string(abi.encodePacked(emailSvg, _email, "</text>"));
    }

    function id(uint256 _tokenId) public view returns (string memory) {
        return string(abi.encodePacked(idSvg, Strings.toString(_tokenId)));
    }

    function makeIdNFT(
        string memory _name,
        string memory _date,
        string memory _email
    ) public {
        uint256 newItemId = _tokenIds.current();

        string memory finalNameSvg = fullName(_name);
        string memory finalDateSvg = dateOfCreation(_date);
        string memory finalEmailSvg = email(_email);
        string memory finalIdSvg = id(newItemId);

        string memory finalSvg = string(
            abi.encodePacked(
                finalNameSvg,
                finalDateSvg,
                finalEmailSvg,
                finalIdSvg,
                "</text></g></g></svg>"
            )
        );

        console.log(finalSvg);

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Your NFT ID", "description": "Your NFT ID Card", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
