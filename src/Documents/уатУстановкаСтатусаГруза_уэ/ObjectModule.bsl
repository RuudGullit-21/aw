
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда    
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда    
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого ТекГруз Из Грузы Цикл 
		Если ТекГруз.ЗаказГрузоотправителя.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам 
			И Не ЗначениеЗаполнено(ТекГруз.ГрузовоеМесто) Тогда
			
			ТекстНСТР = НСтр("en='In line No. %1 there is an order with details on the cargo spaces."
"For this order it is necessary to specify the cargo space.';ru='В строке №%1 указан заказ с детализацией по грузовым местам."
"Для данного заказа необходимо указать грузовое место.'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ТекГруз.НомерСтроки);

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР, ЭтотОбъект, "Грузы["+Формат(ТекГруз.НомерСтроки-1, "ЧН=0; ЧГ=0")+"].ГрузовоеМесто",, Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("мсвЗаказов", Грузы.ВыгрузитьКолонку("ЗаказГрузоотправителя"));
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументуатЗаказГрузоотправителя.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ДокументуатЗаказГрузоотправителя.Мультимодальный
	|				И НЕ ДокументуатЗаказГрузоотправителя.ЭтоЭтап
	|			ТОГДА ЕСТЬNULL(ТабСтатусовРодительскихЗаказов.СтатусЗаказа, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый))
	|		ИНАЧЕ ВЫБОР
	|				КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕСТЬNULL(уатСтатусыГрузов_уэСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый))) > 1
	|					ТОГДА ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Составной)
	|				ИНАЧЕ МАКСИМУМ(ЕСТЬNULL(уатСтатусыГрузов_уэСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый)))
	|			КОНЕЦ
	|	КОНЕЦ КАК СтатусЗаказа
	|ПОМЕСТИТЬ ВТ_СтатусыЗаказов
	|ИЗ
	|	Документ.уатЗаказГрузоотправителя КАК ДокументуатЗаказГрузоотправителя
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатСтатусыГрузов_уэ.СрезПоследних(, НЕ Регистратор = &Регистратор) КАК уатСтатусыГрузов_уэСрезПоследних
	|		ПО (уатСтатусыГрузов_уэСрезПоследних.Заказ = ДокументуатЗаказГрузоотправителя.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СтатусыРодительскихЗаказов.ЗаказГрузоотправителя КАК ЗаказГрузоотправителя,
	|			ВЫБОР
	|				КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕСТЬNULL(СтатусыРодительскихЗаказов.СтатусЗаказа, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый))) > 1
	|					ТОГДА ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Составной)
	|				ИНАЧЕ МАКСИМУМ(ЕСТЬNULL(СтатусыРодительскихЗаказов.СтатусЗаказа, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый)))
	|			КОНЕЦ КАК СтатусЗаказа
	|		ИЗ
	|			(ВЫБРАТЬ
	|				уатЭтапыМультимодальныхПеревозок_уэ.ЗаказГрузоотправителя КАК ЗаказГрузоотправителя,
	|				уатЭтапыМультимодальныхПеревозок_уэ.Этап КАК Этап,
	|				ВЫБОР
	|					КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕСТЬNULL(уатСтатусыГрузов_уэСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый))) > 1
	|						ТОГДА ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Составной)
	|					ИНАЧЕ МАКСИМУМ(ЕСТЬNULL(уатСтатусыГрузов_уэСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Новый)))
	|				КОНЕЦ КАК СтатусЗаказа
	|			ИЗ
	|				РегистрСведений.уатЭтапыМультимодальныхПеревозок_уэ КАК уатЭтапыМультимодальныхПеревозок_уэ
	|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатСтатусыГрузов_уэ.СрезПоследних(, НЕ Регистратор = &Регистратор) КАК уатСтатусыГрузов_уэСрезПоследних
	|					ПО (уатСтатусыГрузов_уэСрезПоследних.Заказ = уатЭтапыМультимодальныхПеревозок_уэ.Этап)
	|			
	|			СГРУППИРОВАТЬ ПО
	|				уатЭтапыМультимодальныхПеревозок_уэ.ЗаказГрузоотправителя,
	|				уатЭтапыМультимодальныхПеревозок_уэ.Этап) КАК СтатусыРодительскихЗаказов
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СтатусыРодительскихЗаказов.ЗаказГрузоотправителя) КАК ТабСтатусовРодительскихЗаказов
	|		ПО ДокументуатЗаказГрузоотправителя.Ссылка = ТабСтатусовРодительскихЗаказов.ЗаказГрузоотправителя
	|ГДЕ
	|	ДокументуатЗаказГрузоотправителя.Ссылка В(&мсвЗаказов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументуатЗаказГрузоотправителя.Ссылка,
	|	ТабСтатусовРодительскихЗаказов.СтатусЗаказа,
	|	ДокументуатЗаказГрузоотправителя.Мультимодальный,
	|	ДокументуатЗаказГрузоотправителя.ЭтоЭтап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_СтатусыЗаказов.Ссылка КАК Ссылка
	|ИЗ
	|	ВТ_СтатусыЗаказов КАК ВТ_СтатусыЗаказов
	|ГДЕ
	|	(ВТ_СтатусыЗаказов.СтатусЗаказа = ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Закрыт)
	|			ИЛИ ВТ_СтатусыЗаказов.СтатусЗаказа = ЗНАЧЕНИЕ(Справочник.уатСтатусы_уэ.Отклонен))";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		ТекстНСТР = НСтр("en='Order ""%1"" has already been closed/rejected. Status change is impossible.';ru='Заказ ""%1"" уже был закрыт/отклонен. Изменение статуса невозможно.'");
		ТекстНСТР = СтрШаблон(ТекстНСТР, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР,,,, Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатУстановкаСтатусаГруза_уэ.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение_уэ.ОтразитьСтатусыГрузов(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатУстановкаСтатусаГруза_уэ.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатЗаказГрузоотправителя") 
			ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатЗаказГрузоотправителя") Тогда
		СтандартнаяОбработка = Ложь;
		
		Если ДанныеЗаполнения.Мультимодальный И Не ДанныеЗаполнения.ЭтоЭтап Тогда 
			Возврат;
		КонецЕсли;
		
		Дата                      = ТекущаяДата();
		ДатаВремяУстановкиСтатуса = ТекущаяДата();
		ДокументОснование         = ДанныеЗаполнения.Ссылка;
		Организация               = ДанныеЗаполнения.Организация;
		
		Если ДанныеЗаполнения.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда 
			Для Каждого ТекГруз Из ДанныеЗаполнения.ГрузовойСостав Цикл 
				НовСтрока = Грузы.Добавить();
				НовСтрока.ЗаказГрузоотправителя = ДанныеЗаполнения.Ссылка;
				НовСтрока.ГрузовоеМесто         = ТекГруз.ГрузовоеМесто;
			КонецЦикла;
		Иначе 
			НовСтрока = Грузы.Добавить();
			НовСтрока.ЗаказГрузоотправителя = ДанныеЗаполнения.Ссылка;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.уатГрузовыеМеста_уэ") Тогда
		
		Дата                      = ТекущаяДата();
		ДатаВремяУстановкиСтатуса = ТекущаяДата();
		Организация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(),
			"ОсновнаяОрганизация");

		НовСтрока = Грузы.Добавить();
		НовСтрока.ГрузовоеМесто  = ДанныеЗаполнения.Ссылка;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
