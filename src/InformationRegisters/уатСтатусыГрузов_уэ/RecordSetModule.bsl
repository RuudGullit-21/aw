
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	Исключение
		Регистратор = Неопределено;
	КонецПопытки;
	
	Если НЕ Отказ 
		И НЕ ТипЗнч(Регистратор) = Тип("ДокументСсылка.уатЗаказГрузоотправителя") Тогда
		
		Для Каждого ТекЗапись Из ЭтотОбъект Цикл
			
			Если ТекЗапись.Статус = Справочники.уатСтатусы_уэ.Отклонен Тогда
				ТекДок = ТекЗапись.Заказ.ПолучитьОбъект();
				
				ТекстОшибкиЗаписи = "";
				
				Попытка 
					ТекДок.ДополнительныеСвойства.Вставить("НеФормироватьДвиженийПоУслугам", Истина);
					ТекДок.Записать(РежимЗаписиДокумента.Проведение);
				Исключение
					ТекстОшибкиЗаписи = ОписаниеОшибки();
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;

	Если Не Отказ И ПолучитьФункциональнуюОпцию("уатИспользоватьУведомления_уэ") Тогда
	
		Если ЭтотОбъект.Количество() > 0 И ДополнительныеСвойства.Свойство("ПредыдущиеЗаписи") Тогда
			// Создание новых записей регистра после удаления старых.
			СформироватьУведомленияПоТекущимЗаписям(ДополнительныеСвойства.ПредыдущиеЗаписи);
		ИначеЕсли ЭтотОбъект.Количество() > 0 Тогда
			// Создание новых записей регистра без удаления старых.
			ПредыдущиеЗаписи = ЭтотОбъект.ВыгрузитьКолонки("Заказ, ГрузовоеМесто, Статус, Период");
			СформироватьУведомленияПоТекущимЗаписям(ПредыдущиеЗаписи);
		ИначеЕсли ЭтотОбъект.Количество() = 0 Тогда
			// Удаление записей регистра.
			// Запоминаются старые значения записей регистра перед их удалением.
			ЭтотОбъект.Прочитать();
			ТаблицаСтатусов = ЭтотОбъект.Выгрузить(,"Заказ, ГрузовоеМесто, Статус, Период");
			ЭтотОбъект.Очистить();
			
			ДополнительныеСвойства.Вставить("ПредыдущиеЗаписи", ТаблицаСтатусов);
			
		КонецЕсли;
	
	КонецЕсли;	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	// Уведомления
	Если Не Отказ И ДополнительныеСвойства.Свойство("НовыеЗаписи") Тогда
		
		// Проверка наличия правил формирования уведомлений по событию "Изменение статуса родительского заказа".
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	уатПравилаФормированияУведомлений_уэ.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.уатПравилаФормированияУведомлений_уэ КАК уатПравилаФормированияУведомлений_уэ
		|ГДЕ
		|	уатПравилаФормированияУведомлений_уэ.ТипСобытия = &ТипСобытия");
		Запрос.УстановитьПараметр("ТипСобытия", Перечисления.уатТипыСобытийДляУведомления_уэ.ИзменениеСтатусаРодительскогоЗаказа);
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	НовыеЗаписи.Заказ КАК Заказ,
			|	НовыеЗаписи.Статус КАК Статус,
			|	НовыеЗаписи.Период КАК Период
			|ПОМЕСТИТЬ втНовыеЗаписи
			|ИЗ
			|	&НовыеЗаписи КАК НовыеЗаписи
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	втНовыеЗаписи.Статус КАК ПотенциальныйНовыйСтатус,
			|	уатЗаказГрузоотправителя.РодительскийЗаказ КАК РодительскийЗаказ,
			|	втНовыеЗаписи.Период КАК ДатаУстановкиСтатуса
			|ПОМЕСТИТЬ втРодительскиеЗаказыСоСтатусами
			|ИЗ
			|	Документ.уатЗаказГрузоотправителя КАК уатЗаказГрузоотправителя
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втНовыеЗаписи КАК втНовыеЗаписи
			|		ПО (втНовыеЗаписи.Заказ = уатЗаказГрузоотправителя.Ссылка)
			|ГДЕ
			|	уатЗаказГрузоотправителя.Мультимодальный = ИСТИНА
			|	И уатЗаказГрузоотправителя.ЭтоЭтап = ИСТИНА
			|
			|СГРУППИРОВАТЬ ПО
			|	уатЗаказГрузоотправителя.РодительскийЗаказ,
			|	втНовыеЗаписи.Статус,
			|	втНовыеЗаписи.Период
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	уатЭтапыМультимодальныхПеревозок_уэ.ЗаказГрузоотправителя КАК ЗаказГрузоотправителя,
			|	уатЭтапыМультимодальныхПеревозок_уэ.Этап КАК Этап
			|ПОМЕСТИТЬ втРодительскиеЗаказыСЭтапами
			|ИЗ
			|	РегистрСведений.уатЭтапыМультимодальныхПеревозок_уэ КАК уатЭтапыМультимодальныхПеревозок_уэ
			|ГДЕ
			|	уатЭтапыМультимодальныхПеревозок_уэ.ЗаказГрузоотправителя В
			|			(ВЫБРАТЬ
			|				втРодительскиеЗаказыСоСтатусами.РодительскийЗаказ
			|			ИЗ
			|				втРодительскиеЗаказыСоСтатусами КАК втРодительскиеЗаказыСоСтатусами)
			|
			|СГРУППИРОВАТЬ ПО
			|	уатЭтапыМультимодальныхПеревозок_уэ.ЗаказГрузоотправителя,
			|	уатЭтапыМультимодальныхПеревозок_уэ.Этап
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	втРодительскиеЗаказыСЭтапами.ЗаказГрузоотправителя КАК ЗаказГрузоотправителя,
			|	ВЫБОР
			|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕСТЬNULL(уатСтатусыГрузов_уэСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый))) > 1
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Составной)
			|		ИНАЧЕ МАКСИМУМ(ЕСТЬNULL(уатСтатусыГрузов_уэСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый)))
			|	КОНЕЦ КАК СтатусЗаказа
			|ПОМЕСТИТЬ втСтатусыРодительскихЗаказов
			|ИЗ
			|	втРодительскиеЗаказыСЭтапами КАК втРодительскиеЗаказыСЭтапами
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатСтатусыГрузов_уэ.СрезПоследних КАК уатСтатусыГрузов_уэСрезПоследних
			|		ПО (уатСтатусыГрузов_уэСрезПоследних.Заказ = втРодительскиеЗаказыСЭтапами.Этап)
			|
			|СГРУППИРОВАТЬ ПО
			|	втРодительскиеЗаказыСЭтапами.ЗаказГрузоотправителя
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	втСтатусыРодительскихЗаказов.ЗаказГрузоотправителя КАК ЗаказГрузоотправителя,
			|	втРодительскиеЗаказыСоСтатусами.ПотенциальныйНовыйСтатус КАК Статус,
			|	втРодительскиеЗаказыСоСтатусами.ДатаУстановкиСтатуса КАК ДатаУстановкиСтатуса
			|ИЗ
			|	втРодительскиеЗаказыСоСтатусами КАК втРодительскиеЗаказыСоСтатусами
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСтатусыРодительскихЗаказов КАК втСтатусыРодительскихЗаказов
			|		ПО втРодительскиеЗаказыСоСтатусами.ПотенциальныйНовыйСтатус = втСтатусыРодительскихЗаказов.СтатусЗаказа
			|			И втРодительскиеЗаказыСоСтатусами.РодительскийЗаказ = втСтатусыРодительскихЗаказов.ЗаказГрузоотправителя");
			Запрос.УстановитьПараметр("НовыеЗаписи", ДополнительныеСвойства.НовыеЗаписи);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ДополнительныеПараметры = Новый Структура("Статус, ДатаУстановкиСтатуса", Выборка.Статус, Выборка.ДатаУстановкиСтатуса);
				уатОбщегоНазначения_уэ.СформироватьУведомление(
					Выборка.ЗаказГрузоотправителя,
					Перечисления.уатТипыСобытийДляУведомления_уэ.ИзменениеСтатусаРодительскогоЗаказа,
					ДополнительныеПараметры
				);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьУведомленияПоТекущимЗаписям(ПредыдущиеЗаписи)
	// Старые записи сравниваются с новыми, находятся записи, которых раньше не было, для них формируются уведомления.
	ТекущиеЗаписи = ЭтотОбъект.Выгрузить(,"Заказ, ГрузовоеМесто, Статус, Период, Регистратор");
	НовыеЗаписи = ТекущиеЗаписи.СкопироватьКолонки();
	
	// Не отслеживается изменение времени установки уже установленного статуса - колонки Период
	СтруктураПоиска = Новый Структура("Заказ, ГрузовоеМесто, Статус");
	Для Каждого ТекСтрока Из ТекущиеЗаписи Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, ТекСтрока);
		Если ПредыдущиеЗаписи.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			НоваяСтрока = НовыеЗаписи.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	Если НовыеЗаписи.Количество() > 0 Тогда
		ДополнительныеСвойства.Вставить("НовыеЗаписи", НовыеЗаписи);
	КонецЕсли;
	
	Для Каждого ТекСтрока Из НовыеЗаписи Цикл
		СформироватьУведомлениеПоЗаписи(ТекСтрока);
	КонецЦикла;
КонецПроцедуры
	
Процедура СформироватьУведомлениеПоЗаписи(ТекЗапись)
	
	Если НЕ ЗначениеЗаполнено(ТекЗапись.Заказ) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Статус", ТекЗапись.Статус);
	ДополнительныеПараметры.Вставить("ДатаУстановкиСтатуса", ТекЗапись.Период);
	Если ТипЗнч(ТекЗапись.Регистратор) = Тип("ДокументСсылка.уатМаршрутныйЛист") Тогда
		ДополнительныеПараметры.Вставить("ДополнительныйДокумент", ТекЗапись.Регистратор);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ТекЗапись.ГрузовоеМесто) Тогда
		ДополнительныеПараметры.Вставить("ГрузовоеМесто", ТекЗапись.ГрузовоеМесто);
		ТипСобытия = Перечисления.уатТипыСобытийДляУведомления_уэ.ИзменениеСтатусаГрузовогоМеста;
	Иначе
		ТипСобытия = Перечисления.уатТипыСобытийДляУведомления_уэ.ИзменениеСтатуса;
	КонецЕсли;
	уатОбщегоНазначения_уэ.СформироватьУведомление(
		ТекЗапись.Заказ,
		ТипСобытия,
		ДополнительныеПараметры
	);
КонецПроцедуры

#КонецОбласти