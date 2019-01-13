let AWS = require('aws-sdk');

exports.handler = function(event, context) {
    let message = JSON.parse(event.Records[0].Sns.Message);
    let autoscaling = new AWS.AutoScaling();

    let params = {
        AutoScalingGroupName: message.AutoScalingGroupName,
        LifecycleActionToken: message.LifecycleActionToken,
        LifecycleHookName: message.LifecycleHookName,
        InstanceId: message.EC2InstanceId,
        LifecycleActionResult: "CONTINUE"
    };

    autoscaling.completeLifecycleAction(params, error => {
        error ? context.fail() : context.succeed();
    });
};