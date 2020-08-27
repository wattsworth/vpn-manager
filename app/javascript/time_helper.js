
import formatDistance from "date-fns/formatDistance";
import format from "date-fns/format";

// Ensure it works with turbolinks
document.addEventListener("turbolinks:load", function() {
    const timeHelpers = document.querySelectorAll("[data-time-format]");
    Array.from(timeHelpers).forEach(function(timeHelper) {


        const timeFormat = timeHelper.getAttribute("data-time-format");
        const value = timeHelper.getAttribute("data-time-value");
        const datetime = Date.parse(JSON.parse(value));

        if (timeFormat === "relative") {
            timeHelper.textContent = formatDistance(datetime, new Date());
        }
        else {
            timeHelper.textContent =  format(datetime, timeFormat);
            console.log(format(datetime, timeFormat))
        }
    });
});
