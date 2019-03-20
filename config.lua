Config = {}
Config.Locale = "fr"
--You can add here buttons like inventory menu button. When player click this button, then action will be cancel.
Config.cancel_buttons = {289, 170, 168, 56}

options =
{
  ['seed_weed'] = {
        object = 'prop_weed_01',
        end_object = 'prop_weed_02',
        fail_msg = _U('fail_msg'),
        success_msg = _U('success_msg'),
        start_msg = _U('start_msg'),
        success_item = 'weed',
        first_step = 2.35,
        steps = 7,
        cords = {
          {x = -427.05, y = 1575.25, z = 357, distance = 20.25},
          {x = 2213.05, y = 5576.25, z = 53, distance = 10.25},
          {x = 1198.05, y = -215.25, z = 55, distance = 20.25},
          {x = 706.05, y = 1269.25, z = 358, distance = 10.25},
        },
        animations_start = {
          {lib = 'amb@world_human_gardener_plant@male@enter', anim = 'enter', timeout = '2500'},
          {lib = 'amb@world_human_gardener_plant@male@idle_a', anim = 'idle_a', timeout = '2500'},
        },
        animations_end = {
          {lib = 'amb@world_human_gardener_plant@male@exit', anim ='exit', timeout = '2500'},
          {lib = 'amb@world_human_cop_idles@male@idle_a', anim ='idle_a', timeout = '2500'},
        },
        animations_step = {
          {lib = 'amb@world_human_gardener_plant@male@enter', anim = 'enter', timeout = '2500'},
          {lib = 'amb@world_human_gardener_plant@male@idle_a', anim ='idle_a', timeout = '18500'},
          {lib = 'amb@world_human_gardener_plant@male@exit', anim ='exit', timeout = '2500'},
        },
        grow = {
          2.24, 1.95, 1.65, 1.45, 1.20, 1.00
        },
        questions = {
            {
                title = _U('question_1'),
                steps = {
                    {label = _U('answer_1.1'), value = 1},
                    {label = _U('answer_1.2'), value = 2},
                    {label = _U('answer_1.3'), value = 3}
                },
                correct = 1
            },
            {
                title = _U('question_2'),
                steps = {
                    {label = _U('answer_1.1'), value = 1},
                    {label = _U('answer_1.2'), value = 2},
                    {label = _U('answer_1.3'), value = 3}
                },
                correct = 2
            },
            {
                title = _U('question_3'),
                steps = {
                    {label = _U('answer_3.1'), value = 1},
                    {label = _U('answer_3.2'), value = 2},
                    {label = _U('answer_1.3'), value = 3}
                },
                correct = 3
            },
            {
                title = _U('question_4'),
                steps = {
                    {label = _U('answer_1.1'), value = 1},
                    {label = _U('answer_4.2'), value = 2},
                    {label = _U('answer_4.3'), value = 3}
                },
                correct = 1
            },
            {
                title = _U('question_5'),
                steps = {
                    {label = _U('answer_1.1'), value = 1},
                    {label = _U('answer_1.2'), value = 2},
                    {label = _U('answer_1.3'), value = 3}
                },
                correct = 2
            },
            {
                title = _U('question_6'),
                steps = {
                    {label = _U('answer_1.1'), value = 1},
                    {label = _U('answer_1.2'), value = 2},
                    {label = _U('answer_1.3'), value = 3}
                },
                correct = 1
            },
            {
                title = _U('question_7'),
                steps = {
                    {label = _U('answer_7.1'), value = 1, min = 5, max = 25},
                    {label = _U('answer_7.2'), value = 1, min = 10, max = 15},
                    {label = _U('answer_7.3'), value = 1, min = 2, max = 40}
                },
                correct = 1
            },
        },
      },
}
