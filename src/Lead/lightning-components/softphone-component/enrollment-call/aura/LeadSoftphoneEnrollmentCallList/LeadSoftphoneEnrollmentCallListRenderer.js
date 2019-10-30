({
    unrender: function (component) {
        this.superUnrender();
        console.log('clear interval due to unrender', component.get("v.intId"));

        window.clearInterval(component.get("v.intId"));
    }
})