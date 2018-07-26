$( document ).ready(function() {
    let a = $('.highlight-json').filter(index => {
	return $($('.highlight-json')[index]).html().includes('http://json-schema')
    });
    for (let index = 0; index < a.length; index++) {
	let id = `json_schema_${index}`
	$(a[index]).prev().html(`<a id="${id}_btn">${linkText[1]}</a>`)
	$(a[index]).prev().css('text-align', 'right');
	$(`#${id}_btn`).click(() => {
	    $(a[index]).toggle();
	    let link = $(a[index]).prev().children()
	    if (link.text() === linkText[0]) {
		link.text(linkText[1]);
	    } else {link.text(linkText[0]);}
	});
	$(a[index]).toggle();
    }
});

const linkText = {
    0: 'hide',
    1: '> json schema',
}
