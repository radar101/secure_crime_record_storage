// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 < 0.9.0;

contract NotesContract {
    uint256 public NoteCount = 1;

    struct Note {
        uint256 id;
        string title;
        string description;
    }

    constructor() public {
        notes[0] = Note(0, "Darshan", "The first dapp"); 
    }

    mapping (uint256=>Note) public notes;
    event NoteCreated(uint256 id, string title, string description);
    event NoteDeleted(uint256 id);

    function createNote(string memory _title, string memory _description) public {
        notes[NoteCount] = Note(NoteCount, _title, _description);
        emit NoteCreated(NoteCount, _title, _description);
        NoteCount++;
    }

    function deleteNote(uint256 _id) public {
        delete notes[_id];
        emit NoteDeleted(_id);
        NoteCount--;
    }
}