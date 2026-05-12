(function () {
  var contextPath = document.body.getAttribute("data-context-path") || "";

  var peopleSelect = document.querySelector("#peopleSelect");
  var peopleText = document.querySelector("#peopleText");
  var seatText = document.querySelector("#seatText");
  var totalPriceText = document.querySelector("#totalPriceText");
  var seatNotice = document.querySelector("#seatNotice");
  var seatMap = document.querySelector("#seatMap");
  var dateSelect = document.querySelector("#dateSelect");
  var dateText = document.querySelector("#dateText");
  var timeText = document.querySelector("#timeText");
  var scheduleSelect = document.querySelector("#scheduleSelect");
  var openBookingButton = document.querySelector("#openBookingButton");
  var bookingControls = document.querySelector("#bookingControls");
  var bookingSection = document.querySelector("#bookingSection");
  var submitBookingButton = document.querySelector("#submitBookingButton");
  var selectedSeatInputs = document.querySelector("#selectedSeatInputs");
  var reservationForm = document.querySelector("#reservationForm");
  var currentSeatIdsText = document.body.getAttribute("data-current-seat-ids") || "";
  var autoOpen = document.body.getAttribute("data-auto-open") === "true";

  var seats = [];
  var selectedSeats = [];
  var initialSeatIds = [];

  if (!peopleSelect || !scheduleSelect || !seatMap || !reservationForm) {
    return;
  }

  function parseInitialSeatIds() {
    var parts = currentSeatIdsText.split(",");
    var i;
    var value;

    for (i = 0; i < parts.length; i += 1) {
      value = Number(parts[i]);
      if (value && initialSeatIds.indexOf(value) === -1) {
        initialSeatIds.push(value);
      }
    }
  }

  function isInitialSeat(seatId) {
    return initialSeatIds.indexOf(Number(seatId)) > -1;
  }

  function syncScheduleFields(sourceSelect) {
    if (!sourceSelect || !sourceSelect.value) {
      return;
    }

    scheduleSelect.value = sourceSelect.value;
    if (dateSelect) {
      dateSelect.value = sourceSelect.value;
    }
  }

  function syncSummary() {
    var price = 0;
    var peopleCount = Number(peopleSelect.value || 0);

    if (dateText && dateSelect && dateSelect.selectedOptions.length > 0) {
      dateText.textContent = dateSelect.selectedOptions[0].textContent.trim();
    }

    if (timeText && scheduleSelect.selectedOptions.length > 0) {
      timeText.textContent = scheduleSelect.selectedOptions[0].textContent.trim();
      price = Number(scheduleSelect.selectedOptions[0].getAttribute("data-price") || 0);
    }

    if (totalPriceText) {
      totalPriceText.textContent = formatPrice(price * peopleCount);
    }
  }

  function formatPrice(value) {
    return String(value).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

  function syncSeatInputs() {
    var i;
    var input;

    selectedSeatInputs.innerHTML = "";

    for (i = 0; i < selectedSeats.length; i += 1) {
      input = document.createElement("input");
      input.type = "hidden";
      input.name = "seatId";
      input.value = selectedSeats[i].seatId;
      selectedSeatInputs.appendChild(input);
    }
  }

  function updateSeatState() {
    var peopleCount = Number(peopleSelect.value || 0);
    var seatButtons = document.querySelectorAll(".seat");
    var i;
    var j;
    var seatButton;
    var seatId;
    var selected;

    for (i = 0; i < seatButtons.length; i += 1) {
      seatButton = seatButtons[i];
      seatId = Number(seatButton.getAttribute("data-seat-id"));
      selected = false;

      for (j = 0; j < selectedSeats.length; j += 1) {
        if (selectedSeats[j].seatId === seatId) {
          selected = true;
          break;
        }
      }

      seatButton.classList.toggle("is-selected", selected);

      if (!seatButton.classList.contains("is-reserved") && !seatButton.classList.contains("is-gap")) {
        seatButton.disabled = peopleCount === 0;
      }
    }

    peopleText.textContent = peopleCount;
    seatText.textContent = selectedSeats.length ? getSelectedSeatNames() : "-";

    submitBookingButton.disabled = peopleCount === 0 || selectedSeats.length !== peopleCount;
    seatNotice.textContent = peopleCount === 0
      ? "인원을 먼저 선택해 주세요."
      : peopleCount + "명 좌석을 선택할 수 있습니다.";

    syncSummary();
    syncSeatInputs();
  }

  function getSelectedSeatNames() {
    var names = [];
    var i;

    for (i = 0; i < selectedSeats.length; i += 1) {
      names.push(selectedSeats[i].seatName);
    }

    return names.join(" | ");
  }

  function findSelectedSeatIndex(seatId) {
    var i;

    for (i = 0; i < selectedSeats.length; i += 1) {
      if (selectedSeats[i].seatId === seatId) {
        return i;
      }
    }

    return -1;
  }

  function toggleSeat(seatButton) {
    var peopleCount = Number(peopleSelect.value || 0);
    var seatId;
    var seatName;
    var selectedIndex;

    if (!peopleCount || seatButton.classList.contains("is-reserved") || seatButton.classList.contains("is-gap")) {
      return;
    }

    seatId = Number(seatButton.getAttribute("data-seat-id"));
    seatName = seatButton.getAttribute("data-seat-name");
    selectedIndex = findSelectedSeatIndex(seatId);

    if (selectedIndex > -1) {
      selectedSeats.splice(selectedIndex, 1);
      updateSeatState();
      return;
    }

    if (selectedSeats.length >= peopleCount) {
      seatNotice.textContent = "선택한 인원 " + peopleCount + "명까지만 좌석을 선택할 수 있습니다.";
      return;
    }

    selectedSeats.push({
      seatId: seatId,
      seatName: seatName
    });
    updateSeatState();
  }

  function getRowLabels() {
    var rowLabels = [];
    var i;

    for (i = 0; i < seats.length; i += 1) {
      if (rowLabels.indexOf(seats[i].rowLabel) === -1) {
        rowLabels.push(seats[i].rowLabel);
      }
    }

    return rowLabels;
  }

  function getSeatsByRow(rowLabel) {
    var rowSeats = [];
    var i;

    for (i = 0; i < seats.length; i += 1) {
      if (seats[i].rowLabel === rowLabel) {
        rowSeats.push(seats[i]);
      }
    }

    rowSeats.sort(function (a, b) {
      return a.colNum - b.colNum;
    });

    return rowSeats;
  }

  function renderSeats() {
    var rowLabels;
    var rowIndex;
    var seatIndex;
    var rowLabel;
    var rowSeats;
    var rowElement;
    var labelElement;
    var seat;
    var button;

    seatMap.innerHTML = "";
    rowLabels = getRowLabels();

    for (rowIndex = 0; rowIndex < rowLabels.length; rowIndex += 1) {
      rowLabel = rowLabels[rowIndex];
      rowElement = document.createElement("div");
      rowElement.className = "seat-row";

      labelElement = document.createElement("span");
      labelElement.className = "row-label";
      labelElement.textContent = rowLabel;
      rowElement.appendChild(labelElement);

      rowSeats = getSeatsByRow(rowLabel);

      for (seatIndex = 0; seatIndex < rowSeats.length; seatIndex += 1) {
        seat = rowSeats[seatIndex];
        button = document.createElement("button");
        button.type = "button";
        button.className = "seat";
        button.setAttribute("data-seat-id", seat.seatId);
        button.setAttribute("data-seat-name", seat.seatName);
        button.setAttribute("aria-label", seat.seatName + " 좌석");

        if (seat.reserved && !isInitialSeat(seat.seatId)) {
          button.classList.add("is-reserved");
          button.disabled = true;
        }

        button.addEventListener("click", createSeatClickHandler(button));
        rowElement.appendChild(button);
      }

      seatMap.appendChild(rowElement);
    }

    updateSeatState();
  }

  function createSeatClickHandler(button) {
    return function () {
      toggleSeat(button);
    };
  }

  function resetSeats(message) {
    seats = [];
    selectedSeats = [];
    seatMap.innerHTML = "";
    updateSeatState();
    seatNotice.textContent = message;
  }

  function loadSeats() {
    var scheduleId = scheduleSelect.value;
    var request;

    if (!scheduleId) {
      resetSeats("상영 시간을 선택해 주세요.");
      return;
    }

    request = new XMLHttpRequest();
    request.open("GET", contextPath + "/seat/list.do?scheduleId=" + encodeURIComponent(scheduleId), true);
    request.onreadystatechange = function () {
      var data;

      if (request.readyState !== 4) {
        return;
      }

      if (request.status < 200 || request.status >= 300) {
        resetSeats("좌석을 불러오는 중 오류가 발생했습니다.");
        return;
      }

      try {
        data = JSON.parse(request.responseText);
      } catch (error) {
        resetSeats("좌석을 불러오는 중 오류가 발생했습니다.");
        return;
      }

      if (!data.success) {
        resetSeats(data.message || "좌석을 불러오지 못했습니다.");
        return;
      }

      seats = data.seats || [];
      selectedSeats = [];
      for (var i = 0; i < seats.length; i += 1) {
        if (isInitialSeat(seats[i].seatId)) {
          selectedSeats.push({
            seatId: Number(seats[i].seatId),
            seatName: seats[i].seatName
          });
        }
      }
      renderSeats();
    };
    request.send();
  }

  parseInitialSeatIds();

  if (openBookingButton) {
    openBookingButton.addEventListener("click", function () {
      openBookingButton.hidden = true;
      bookingControls.hidden = false;
      bookingSection.hidden = false;
      loadSeats();
    });
  }

  if (dateSelect) {
    dateSelect.addEventListener("change", function () {
      syncScheduleFields(dateSelect);
      loadSeats();
    });
  }

  scheduleSelect.addEventListener("change", function () {
    syncScheduleFields(scheduleSelect);
    loadSeats();
  });

  peopleSelect.addEventListener("change", function () {
    selectedSeats = [];
    updateSeatState();
  });

  reservationForm.addEventListener("submit", function (event) {
    var peopleCount = Number(peopleSelect.value || 0);

    if (peopleCount === 0 || selectedSeats.length !== peopleCount) {
      event.preventDefault();
      seatNotice.textContent = "인원 수에 맞게 좌석을 선택해 주세요.";
    }
  });

  if (autoOpen) {
    if (openBookingButton) {
      openBookingButton.hidden = true;
    }
    if (bookingControls) {
      bookingControls.hidden = false;
    }
    if (bookingSection) {
      bookingSection.hidden = false;
    }
    loadSeats();
  }

  syncSummary();
}());
