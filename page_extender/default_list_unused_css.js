
(function() {
	for (var i=0;i<document.styleSheets.length;i++) {
		var rules = document.styleSheets[i].cssRules || [];
		var sheethref = document.styleSheets[i].href || 'inline';
		for (var r=0;r<rules.length;r++)
			if (!document.querySelectorAll(rules[r].selectorText).length)
				console.log(sheethref + ': "' + rules[r].selectorText + '" not found.');
	}
})();

