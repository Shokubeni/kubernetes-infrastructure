"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var CommandStatus;
(function (CommandStatus) {
    CommandStatus["Pending"] = "Pending";
    CommandStatus["InProgress"] = "InProgress";
    CommandStatus["Delayed"] = "Delayed";
    CommandStatus["Success"] = "Success";
    CommandStatus["Cancelled"] = "Cancelled";
    CommandStatus["Failed"] = "Failed";
    CommandStatus["TimedOut"] = "TimedOut";
    CommandStatus["Cancelling"] = "Cancelling";
})(CommandStatus = exports.CommandStatus || (exports.CommandStatus = {}));
