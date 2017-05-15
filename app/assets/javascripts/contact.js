$(document).ready(function() {
    if (getSourcePage() !== 'contact') return;

	console.log("contact");

	setTimeout(function() { $('.logo-pendant').fadeIn('slow'); }, 1000);
	initLanguageFormHandler();
});