---
layout: post
title: 'Angular tip of the week: parametrized templates'
date: 2021-03-05 19:23 +0200
tags: []
categories: []
---

On my 30-th week of Angular, I learned something that I was looking for since the first week: a lightweight way to get a “parametrized” piece of view. Coming from a couple of years of React, I was used to having function components to abstract away noisy bits of a view, and for some time I thought the only way to get that is to get such a thing.

It’s of course not as clean as it would have been in React, but it works, and it’s more ad-hoc than a new component.

## TLDR

```html
<ng-container
    [ngTemplateOutlet]="songTemplate"
    [ngTemplateOutletContext]="{ title: 'It’s My Life', artist: 'Dr. Alban' }"
></ng-container>

<ng-container
    [ngTemplateOutlet]="songTemplate"
    [ngTemplateOutletContext]="{ title: 'This is the way', artist: 'E-Type' }"
></ng-container>

<ng-template #songTemplate let-title="title" let-artist="artist">{% raw %}
    <h3>{{ title }}</h3>
    <p>by {{ artist }}</p>
{% endraw %}</ng-template>
```

Yes, I should have “read the fine manual,” but there are a million other things to learn when you get into a new tech, so, assuming that there are more people in this situation, here it is. Also, check the docs for more depth if needed: [https://angular.io/api/common/NgTemplateOutlet][0].

[0]: https://angular.io/api/common/NgTemplateOutlet


