/*
 * Class for Calendar
 */
!function() {
	function Calendar(selector) {
	    this.el = document.querySelector(selector);
	    this.events = new Array();
	    var date = getQueryParams().date;
	    this.target = date ? moment(date) : null;
	    this.current = this.target ? moment(this.target).date(1) : moment().date(1);
	    this.initial = true;
	    this.calendarMode = true;
	    this.chinese = isChinese();
	    this.draw();
	    var current = this.target ? document.querySelector('.target') : document.querySelector('.today');
	    if (current) {
	     	var self = this;
	      	window.setTimeout(function() {
	        	self.openDay(current);
	      	}, 500);
	    }
	}

	Calendar.prototype.draw = function() {
	    this.drawHeader();
	    this.getEvents();
	    this.drawMonth();
	    if (this.initial) {
	    	this.drawOthers();
	    	this.initial = false;
	    }
	}

	Calendar.prototype.drawHeader = function() {
	    var self = this;
	    if (!this.header) {
	      	this.header = createElement('div', 'calendar-header');
	      	this.header.className = 'calendar-header';

	      	this.title = createElement('h1');

	      	var right = createElement('div', 'right');
	      	right.addEventListener('click', function() { self.nextMonth(); });

	      	var left = createElement('div', 'left');
	      	left.addEventListener('click', function() { self.prevMonth(); });

	      	this.header.appendChild(this.title); 
	      	this.header.appendChild(right);
	      	this.header.appendChild(left);
	      	this.el.appendChild(this.header);
	    }

	    this.title.innerHTML = this.current.format('MMMM YYYY');
	}

	Calendar.prototype.drawMonth = function() {
	    var self = this;
	    if (this.month) {
	      	this.oldMonth = this.month;
	      	this.oldMonth.className = 'month out ' + (self.next ? 'next' : 'prev');
	      	this.oldMonth.addEventListener('webkitAnimationEnd', function() {
	        	self.oldMonth.parentNode.removeChild(self.oldMonth);
	        	self.month = createElement('div', 'month');
	        	self.backFill();
	        	self.currentMonth();
	        	self.fowardFill();
	        	self.el.appendChild(self.month);
	        	window.setTimeout(function() {
	          		self.month.className = 'month in ' + (self.next ? 'next' : 'prev');
	       	 	}, 16);
	      	});
	      	this.currentMonthLargeIcon();
	    } else {
		    this.month = createElement('div', 'month');
		    this.monthAlt = createElement('div', 'month-alt');
		    this.el.appendChild(this.month);
		    this.el.appendChild(this.monthAlt);
		    this.backFill();
		    this.currentMonth();
		    this.currentMonthLargeIcon();
		    this.fowardFill();
		    this.month.className = 'month new';
	    }
	    if (!this.calendarMode) updateHeader(this.chinese, this.current, this.events, this.calendarMode);
	}

	Calendar.prototype.backFill = function() {
		var clone = this.current.clone();
		var dayOfWeek = clone.day();

		if (!dayOfWeek) return;

		clone.subtract('days', dayOfWeek+1);

		for(var i = dayOfWeek; i > 0 ; i--)
			this.drawDay(clone.add('days', 1));
	}

	Calendar.prototype.fowardFill = function() {
		var clone = this.current.clone().add('months', 1).subtract('days', 1);
		var dayOfWeek = clone.day();

		if (dayOfWeek === 6) return;

		for(var i = dayOfWeek; i < 6 ; i++)
		   	this.drawDay(clone.add('days', 1));
	}

	Calendar.prototype.currentMonth = function() {
	   	var clone = this.current.clone();

		while(clone.month() === this.current.month()) {
		    this.drawDay(clone);
		    clone.add('days', 1);
		}
	}

	Calendar.prototype.currentMonthLargeIcon = function() {
		var dollarSign = this.chinese ? '¥' : '$';
		this.currentIndex = 0;
		this.monthAlt.innerHTML = '';
		for (var i = this.currentIndex; i < this.currentIndex + 3; i++) {
			if (this.events[i] === undefined) break;
			this.monthAlt.innerHTML += '<div class="product-container col-xs-12 col-sm-6 col-lg-4">' +
  										'<div class="kicks-box" style="background-image:url(' + this.events[i].image + ')">' +
    									'<div class="cover top-left">' +
      									'<h2 class="title">' + this.events[i].eventName + '</h2>' +
      									'<span class="date">' + dollarSign + ' ' + parseFloat(this.events[i].price).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,') + 
      									'</span></div></div><span style="color:#4A4A4A;width:100%">' + this.events[i].date.format('MM/DD') + '</span></div></div>';
		}
		this.currentIndex += 3;
		if (this.events[this.currentIndex] !== undefined)
			this.monthAlt.innerHTML += '<div class="to-view-more"><span>' + (this.chinese ? '点击加载更多' : 'Click To View More') + ' <i class="fa fa-arrow-circle-down" aria-hidden="true"></i></span></div>';


		if (this.initial) {
			var self = this;
			 $('.month-alt').on('click', '.to-view-more' , function() {
				this.remove();

				// copy the function currentMonthLargeIcon code instead of calling it directly to prevent stack overflow
				for (var i = self.currentIndex; i < self.currentIndex + 3; i++) {
					if (self.events[i] === undefined) break;
					self.monthAlt.innerHTML += '<div class="product-container col-xs-12 col-sm-6 col-lg-4">' +
  										'<div class="kicks-box" style="background-image:url(' + self.events[i].image + ')">' +
    									'<div class="cover top-left">' +
      									'<h2 class="title">' + self.events[i].eventName + '</h2>' +
      									'<span class="date">' + dollarSign + ' ' + parseFloat(self.events[i].price).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,') + 
      									'</span></div></div><span style="color:#4A4A4A;width:100%">' + self.events[i].date.format('MM/DD') + '</span></div></div>';
				}
				self.currentIndex += 3;
				if (self.events[self.currentIndex] !== undefined)
					self.monthAlt.innerHTML += '<div class="to-view-more"><span>' + (self.chinese ? '点击加载更多' : 'Click To View More') + ' <i class="fa fa-arrow-circle-down" aria-hidden="true"></i></span></div>';
				this.remove();
			});
		}
	}

	Calendar.prototype.getWeek = function(day) {
	    if (!this.week || day.day() === 0) {
	      	this.week = createElement('div', 'week');
	      	this.month.appendChild(this.week);
	    }
	}

	Calendar.prototype.drawDay = function(day) {
	    var self = this;
	    this.getWeek(day);

	    var outer = createElement('div', this.getDayClass(day));
	    outer.addEventListener('click', function() {
	     	self.openDay(this);
	    });

	    var name = createElement('div', 'day-name', day.format('ddd'));
	    var number = createElement('div', 'day-number', day.format('DD'));

	    var events = createElement('div', 'day-events');
	    this.drawEvents(day, events);

		outer.appendChild(name);
		outer.appendChild(number);
		outer.appendChild(events);
		this.week.appendChild(outer);
	}

	Calendar.prototype.drawEvents = function(day, element) {
	    if (day.month() === this.current.month()) {
	      	var todaysEvents = this.events.reduce(function(memo, ev) {
	        	if (ev.date.isSame(day, 'day')) memo.push(ev);
	        	return memo;
	      	}, []);

	      	todaysEvents.forEach(function(ev) {
	        	var evSpan = createElement('span', ev.color);
	        	element.appendChild(evSpan);
	      	});
	    }
	}

	Calendar.prototype.getDayClass = function(day) {
	    classes = ['day'];
	    if (day.month() !== this.current.month())
	      	classes.push('other');
	    else if (moment().isSame(day, 'day'))
	      	classes.push('today');
	    else if (this.target && this.target.isSame(day, 'day'))
	    	classes.push('target');
	    return classes.join(' ');
	}

	Calendar.prototype.openDay = function(el) {
	    var details, arrow;
	    var dayNumber = +el.querySelectorAll('.day-number')[0].innerText || +el.querySelectorAll('.day-number')[0].textContent;
	    var day = this.current.clone().date(dayNumber);

		var currentOpened = document.querySelector('.details');

		// Check to see if there is an open detais box on the current row
		if(currentOpened && currentOpened.parentNode === el.parentNode) {
		    details = currentOpened;
		    arrow = document.querySelector('.arrow');
		} else {
	      	// Close the open events on differnt week row
	      	if (currentOpened) {
		        currentOpened.addEventListener('webkitAnimationEnd', function() {
		          	currentOpened.parentNode.removeChild(currentOpened);
		        });
		        currentOpened.addEventListener('oanimationend', function() {
		          	currentOpened.parentNode.removeChild(currentOpened);
		        });
		        currentOpened.addEventListener('msAnimationEnd', function() {
		          	currentOpened.parentNode.removeChild(currentOpened);
		        });
		        currentOpened.addEventListener('animationend', function() {
		          	currentOpened.parentNode.removeChild(currentOpened);
		        });
		        currentOpened.className = 'details out';
	      	}

	  		// Create the Details Container
	  		details = createElement('div', 'details in');

	  		//Create the arrow
	  		var arrow = createElement('div', 'arrow');

	  		//Create the event wrapper
	  		details.appendChild(arrow);
	  		el.parentNode.appendChild(details);
		}

		var todaysEvents = this.events.reduce(function(memo, ev) {
	  		if (ev.date.isSame(day, 'day')) memo.push(ev);
	  		return memo;
		}, []);

		this.renderEvents(todaysEvents, details);
		arrow.style.left = el.offsetLeft - el.parentNode.offsetLeft + (el.parentNode.clientWidth/15.6) + 'px';
		updateHeader(this.chinese, day, todaysEvents, this.calendarMode);
	}

	Calendar.prototype.renderEvents = function(events, ele) {
		// Remove any events in the current details element
		var currentWrapper = ele.querySelector('.events');
		var wrapper = createElement('div', 'events in' + (currentWrapper ? ' new' : ''));
		var dollarSign = this.chinese ? '¥' : '$';

		events.forEach(function(ev) {
	  		var div = createElement('div', 'event');
	  		var square = createElement('div', 'event-category ' + ev.color);
	  		var link = createElement('a', '', ev.eventName);
	  		link.setAttribute('data-toggle', 'modal');
	  		link.setAttribute('data-target', '#release-modal');
	  		link.setAttribute('data-title', ev.eventName);
	  		link.setAttribute('data-price', ev.price);
	  		link.setAttribute('data-image', ev.image);

	      	div.appendChild(square);
	      	div.appendChild(link);
	      	wrapper.appendChild(div);

	      	link.addEventListener('click', function() {
	      		var priceList = document.querySelectorAll('#release-modal .modal-footer span');
	      		Array.prototype.forEach.call(priceList, function(node) {node.remove();});

	      		var data = this.dataset;
	      		var modal = document.getElementById('release-modal');
	      		modal.getElementsByClassName('modal-title')[0].innerText = data.title;
	      		modal.querySelector('.modal-body > img').setAttribute('src', data.image);
	      		var span = createElement('span', '', dollarSign + ' ' + parseFloat(data.price).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
	      		modal.getElementsByClassName('modal-footer')[0].appendChild(span);
	      	});
		});

		if (!events.length) {
	  		var div = createElement('div', 'event empty');
	  		var span = createElement('span', '', this.chinese ? '没有发售活动' : 'No Release');

	  		div.appendChild(span);
	  		wrapper.appendChild(div);
		}

		if (currentWrapper) {
	  		currentWrapper.className = 'events out';
	  		currentWrapper.addEventListener('webkitAnimationEnd', function() {
	    		currentWrapper.parentNode.removeChild(currentWrapper);
	    		ele.appendChild(wrapper);
	  		});
	  		currentWrapper.addEventListener('oanimationend', function() {
	        	currentWrapper.parentNode.removeChild(currentWrapper);
	        	ele.appendChild(wrapper);
	  		});
	      	currentWrapper.addEventListener('msAnimationEnd', function() {
		        currentWrapper.parentNode.removeChild(currentWrapper);
		        ele.appendChild(wrapper);
	      	});
	      	currentWrapper.addEventListener('animationend', function() {
		        currentWrapper.parentNode.removeChild(currentWrapper);
		        ele.appendChild(wrapper);
	      	});
		} else {
	  		ele.appendChild(wrapper);
		}
	}

	Calendar.prototype.getEvents = function() {
		var self = this;
		$.ajax({
			type: 'GET',
			async : false,
            url: '/main/get_posts?next_page=1&source_page=calendar&month=' + (this.current.month() + 1) + "&year=" + this.current.year(),
            dataType: "json",
            success: function(data) { 
            	self.events = new Array();
            	data.posts.forEach(function(ev) {
            		self.events.push({
            			eventName: ev.post.title,
            			calendar: ev.post.release_type,
            			color: self.setColor(ev.post.release_type),
            			date: moment(ev.post.release_date),
            			price: ev.post.price,
            			image: ev.image_url
            		});
            	});
            }
		});
		this.events.sort(function(a,b) { return a.date - b.date; });
	}

	Calendar.prototype.setColor = function(calendar) {
		switch(calendar) {
			case 'SNEAKER':
				return 'orange';
			case 'CLOTH':
				return 'blue';
			case 'ACCESSORY':
				return 'yellow';
			default:
				return 'green'
		}
	}

	Calendar.prototype.drawOthers = function() {
		var legend = createElement('div', 'legend');
		legend.appendChild(createElement('span', 'entry orange', this.chinese ? '鞋子' : 'Sneaker'));
		legend.appendChild(createElement('span', 'entry blue', this.chinese ? '服饰' : 'Cloth'));
		legend.appendChild(createElement('span', 'entry yellow', this.chinese ? '配件' : 'Accessory'));
		legend.appendChild(createElement('span', 'entry green', this.chinese ? '其它' : 'Other'));
		this.el.appendChild(legend);

		var self = this;
		document.getElementsByClassName('switch-checkbox')[0].addEventListener('click', function() {
	  		var mainParent = this.parentElement;
	  		if(this.checked) {
	  			$(self.monthAlt).fadeOut();
	    		mainParent.classList.add('active');
	    		$(self.month).slideDown('slow');
	    		legend.removeAttribute('style');
	    		self.calendarMode = true;
	  		} else {
	    		$(self.month).slideUp('slow');
	    		legend.style.display = 'none';
	    		mainParent.classList.remove('active');
	    		$(self.monthAlt).fadeIn();
	    		self.calendarMode = false;
	    		updateHeader(self.chinese, self.current, self.events, self.calendarMode);
	  		}
		});
	}

	Calendar.prototype.nextMonth = function() {
		this.current.add('months', 1);
	    this.next = true;
	    this.draw();
	}

	Calendar.prototype.prevMonth = function() {
	    this.current.subtract('months', 1);
	    this.next = false;
	    this.draw();
	}

	window.Calendar = Calendar;

	function updateHeader(chinese, date, events, calendarMode) {
		var description;
		if (events.length) {
			if (chinese)
				description = '有' + events.length + '件物品发售';
			else
				description = 'has ' + (events.length > 1 ? events.length + ' releases' : '1 release');
		} else
			description = chinese ? '没有发售活动' : 'has no release';
		$('.header').text((calendarMode ? date.format('YYYY-MM-DD') : date.format('YYYY-MM')) + ' ' + description);
	}

	function createElement(tagName, className, innerText) {
		var ele = document.createElement(tagName);
		if (className)
	  		ele.className = className;
		if (innerText)
	  		ele.innderText = ele.textContent = innerText;
		return ele;
	}
}();

$(document).ready(function() {
	if (getSourcePage() !== 'calendar') return;

	// set CALENDAR menu selected
	$('#navbar ul li').eq(2).addClass('active');
	console.log("calendar");

	initCalendar();
	initApplication(true);
});

function initCalendar() {
	try {
  		var calendar = new Calendar('#calendar');
  		setTimeout(function() { 
  			$('.opening-scene').remove();
  			$('body').css('overflow', 'auto');
  			$('span.press-warning').removeClass('hidden'); 
  			$('.switch-checkbox').trigger('click');
  		}, 2500);
  	} catch(e) {
  		var chinese = isChinese();
  		var errorDescription = chinese ? '错误发生当开启日历，请刷新网页重试' : 'Error occur while opening calendar. Please refresh the page.';
  		var retryText = chinese ? '重试' : 'Retry';
  		$('#calendar').empty().css('text-align', 'center').append($('<h3>', {
  			style: 'color:#4A4A4A',
  			text: errorDescription
  		})).append($('<button>', {
  			style: 'color:#4A4A4A',
  			text: retryText,
  			on: {
  				click: function() {location.reload();}
  			}
  		}));
  	}
}