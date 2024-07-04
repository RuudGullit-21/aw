
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	НастройкиКомпоновщикаНастроек = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТабДанныхПоМЛ", 
		ПолучитьДанныеПланФактПробегаПоМаршрутнымЛистам(
			НастройкиКомпоновщикаНастроек.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Значение.ДатаНачала,
			НастройкиКомпоновщикаНастроек.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Значение.ДатаОкончания
		)
	);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновщикаНастроек, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеПланФактПробегаПоМаршрутнымЛистам(Знач ДатаС, Знач ДатаПо)
	
	ПланФактПробегПоМаршрутнымЛистам = Новый ТаблицаЗначений();
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ТС",              Новый ОписаниеТипов("СправочникСсылка.уатТС"));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("МаршрутныйЛист",  Новый ОписаниеТипов("ДокументСсылка.уатМаршрутныйЛист"));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ЗаказНаТС",       Новый ОписаниеТипов("ДокументСсылка.уатЗаказГрузоотправителя"));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ОтправлениеПлан", Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ПрибытиеПлан",    Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ПробегПланМЛ",    Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный)));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ПробегПланЗаказ", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный)));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ОтправлениеФакт", Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ПрибытиеФакт",    Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ПланФактПробегПоМаршрутнымЛистам.Колонки.Добавить("ПробегФакт",      Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный)));
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаС",  ДатаС);
	Запрос.УстановитьПараметр("ДатаПо", ДатаПо);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатМаршрутныйЛист.Ссылка КАК МаршрутныйЛист,
	|	уатМаршрутныйЛист.ТС
	|ИЗ
	|	Документ.уатМаршрутныйЛист КАК уатМаршрутныйЛист
	|ГДЕ
	|	уатМаршрутныйЛист.Дата МЕЖДУ &ДатаС И &ДатаПо
	|	И уатМаршрутныйЛист.Проведен
	|	И НЕ уатМаршрутныйЛист.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		ДеревоЗаказов = СформироватьДеревоЗаказовПоМЛ(Выборка.МаршрутныйЛист);
		ОбновитьМаршрутныеПараметрыДереваЗаказов(ДеревоЗаказов);
		
		кэшУзлыПунктовПоЗаказам = Новый Соответствие();
		
		Для Каждого ТекПункт Из ДеревоЗаказов.Строки Цикл 
			Для Каждого ТекЗаказ Из ТекПункт.Строки Цикл 
				СтрокиЗаказа = ПланФактПробегПоМаршрутнымЛистам.НайтиСтроки(Новый Структура("МаршрутныйЛист, ЗаказНаТС", Выборка.МаршрутныйЛист, ТекЗаказ.ЗаказГрузоотправителя));
				Если СтрокиЗаказа.Количество() = 0 Тогда 
					СтрокаЗаказа = ПланФактПробегПоМаршрутнымЛистам.Добавить();
					СтрокаЗаказа.МаршрутныйЛист  = Выборка.МаршрутныйЛист;
					СтрокаЗаказа.ТС              = Выборка.ТС;
					СтрокаЗаказа.ЗаказНаТС       = ТекЗаказ.ЗаказГрузоотправителя;
					СтрокаЗаказа.ПробегПланЗаказ = ТекЗаказ.ЗаказГрузоотправителя.ПробегСГрузом + ТекЗаказ.ЗаказГрузоотправителя.ПробегПорожний;
					
				Иначе 
					СтрокаЗаказа = СтрокиЗаказа[0];
				КонецЕсли;
				
				Если ТекЗаказ.ТипТочкиМаршрута = Перечисления.уатТипыТочекМаршрута.Погрузка Тогда 
					кэшУзлыПунктовПоЗаказам.Вставить(ТекЗаказ.ЗаказГрузоотправителя, ТекПункт);
					
					СтрокаЗаказа.ОтправлениеПлан = ?(ЗначениеЗаполнено(ТекПункт.УбытиеПлан), ТекПункт.УбытиеПлан, ТекПункт.ПрибытиеПлан);
					СтрокаЗаказа.ОтправлениеФакт = ?(ЗначениеЗаполнено(ТекПункт.УбытиеФакт), ТекПункт.УбытиеФакт, ТекПункт.ПрибытиеФакт);
					
				ИначеЕсли ТекЗаказ.ТипТочкиМаршрута = Перечисления.уатТипыТочекМаршрута.Разгрузка Тогда 
					флСтарт = Ложь;
					ПланПробег = 0;
					Для Каждого ТекСтрока Из ДеревоЗаказов.Строки Цикл 
						Если ТекСтрока = ТекПункт Тогда 
							Прервать;
						КонецЕсли;
						Если ТекСтрока = кэшУзлыПунктовПоЗаказам.Получить(ТекЗаказ.ЗаказГрузоотправителя) Тогда 
							флСтарт = Истина;
						КонецЕсли;
						Если флСтарт Тогда 
							ПланПробег = ПланПробег + ТекСтрока.Расстояние;
						Иначе 
							Продолжить;
						КонецЕсли;
					КонецЦикла;
					
					СтрокаЗаказа.ПробегПланМЛ = ПланПробег;
					
					СтрокаЗаказа.ПрибытиеПлан = ?(ЗначениеЗаполнено(ТекПункт.ПрибытиеПлан), ТекПункт.ПрибытиеПлан, ТекПункт.УбытиеПлан);
					СтрокаЗаказа.ПрибытиеФакт = ?(ЗначениеЗаполнено(ТекПункт.ПрибытиеФакт), ТекПункт.ПрибытиеФакт, ТекПункт.УбытиеФакт);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ТекЗаказ Из ПланФактПробегПоМаршрутнымЛистам Цикл 
		Если ТекЗаказ.ТС.ИсточникФактическихДанныхДляКартографии = Перечисления.уатИсточникФактическихДанныхДляКартографии.СистемаСпутниковогоМониторинга Тогда 
			ЗапросПоGPS = Новый Запрос();
			ЗапросПоGPS.УстановитьПараметр("ТС",      ТекЗаказ.ТС);
			ЗапросПоGPS.УстановитьПараметр("ДатаНач", ?(ЗначениеЗаполнено(ТекЗаказ.ОтправлениеФакт), ТекЗаказ.ОтправлениеФакт, ТекЗаказ.ОтправлениеПлан));
			ЗапросПоGPS.УстановитьПараметр("ДатаКон", ?(ЗначениеЗаполнено(ТекЗаказ.ПрибытиеФакт), ТекЗаказ.ПрибытиеФакт, ТекЗаказ.ПрибытиеПлан));
			
			ЗапросПоGPS.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СУММА(уатПробегРасходПоМониторингу.Пробег) КАК Пробег
			|ИЗ
			|	РегистрСведений.уатПробегРасходПоМониторингу КАК уатПробегРасходПоМониторингу
			|ГДЕ
			|	уатПробегРасходПоМониторингу.ТС = &ТС
			|	И уатПробегРасходПоМониторингу.Период МЕЖДУ &ДатаНач И &ДатаКон";
			
			ВыборкаПоGPS = ЗапросПоGPS.Выполнить().Выбрать();
			Если ВыборкаПоGPS.Следующий() Тогда 
				ТекЗаказ.ПробегФакт = ВыборкаПоGPS.Пробег;
			КонецЕсли;
			
		ИначеЕсли ТекЗаказ.ТС.ИсточникФактическихДанныхДляКартографии = Перечисления.уатИсточникФактическихДанныхДляКартографии.МобильноеПриложение Тогда
			ТекЗаказ.ПробегФакт = уатЗащищенныеФункцииСервер_проф.ПолучитьПробегПоДаннымМобильногоПриложения(
				ТекЗаказ.ТС,
				?(ЗначениеЗаполнено(ТекЗаказ.ОтправлениеФакт), ТекЗаказ.ОтправлениеФакт, ТекЗаказ.ОтправлениеПлан),
				?(ЗначениеЗаполнено(ТекЗаказ.ПрибытиеФакт), ТекЗаказ.ПрибытиеФакт, ТекЗаказ.ПрибытиеПлан)
			);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПланФактПробегПоМаршрутнымЛистам;
	
КонецФункции // ПолучитьДанныеПланФактПробегаПоМаршрутнымЛистам()

Функция ПолучитьПустоеДеревоЗаказов()
	
	ДеревоЗаказов = Новый ДеревоЗначений();
	ДеревоЗаказов.Колонки.Добавить("ПунктЗаказНоменклатура", Новый ОписаниеТипов("СправочникСсылка.уатПунктыНазначения, ДокументСсылка.уатЗаказГрузоотправителя, Строка, СправочникСсылка.Номенклатура, СправочникСсылка.уатГрузовыеМеста_уэ"));
	ДеревоЗаказов.Колонки.Добавить("ПрибытиеФакт",           Новый ОписаниеТипов("Дата"));
	ДеревоЗаказов.Колонки.Добавить("УбытиеФакт",             Новый ОписаниеТипов("Дата"));
	ДеревоЗаказов.Колонки.Добавить("ПрибытиеПлан",           Новый ОписаниеТипов("Дата"));
	ДеревоЗаказов.Колонки.Добавить("УбытиеПлан",             Новый ОписаниеТипов("Дата"));
	ДеревоЗаказов.Колонки.Добавить("ТипТочкиМаршрута",       Новый ОписаниеТипов("ПеречислениеСсылка.уатТипыТочекМаршрута"));
	ДеревоЗаказов.Колонки.Добавить("Время",                  Новый ОписаниеТипов("Число"));
	ДеревоЗаказов.Колонки.Добавить("Расстояние",             Новый ОписаниеТипов("Число"));
	ДеревоЗаказов.Колонки.Добавить("Стоянка",                Новый ОписаниеТипов("Число"));
	ДеревоЗаказов.Колонки.Добавить("СтоянкаИзПункта",        Новый ОписаниеТипов("Число"));
	ДеревоЗаказов.Колонки.Добавить("ЗаказГрузоотправителя",  Новый ОписаниеТипов("ДокументСсылка.уатЗаказГрузоотправителя"));
	
	Возврат ДеревоЗаказов;
	
КонецФункции // ПолучитьПустоеДеревоЗаказов()

Функция СформироватьДеревоЗаказовПоМЛ(Знач МаршрутныйЛист)
	
	Перем НовСтрокаПункт, ПредПункт, НовСтрокаЗаказ, ПредЗаказ, ПредСтрока;
	
	дЗаказыДерево = ПолучитьПустоеДеревоЗаказов();
	
	СменилсяПункт = Ложь;
	ПредСтрока    = Неопределено;
	ПредПункт     = Ложь;
	
	Для Каждого ТекСтрока Из МаршрутныйЛист.Заказы Цикл
		//пункт
		Если ТекСтрока.ТипТочкиМаршрута = Перечисления.уатТипыТочекМаршрута.Погрузка Тогда
			ТекПункт = ?(ЗначениеЗаполнено(ТекСтрока.Пункт), ТекСтрока.Пункт, ТекСтрока.ЗаказГрузоотправителя.АдресОтправления);
		ИначеЕсли ТекСтрока.ТипТочкиМаршрута = Перечисления.уатТипыТочекМаршрута.Разгрузка Тогда
			ТекПункт = ?(ЗначениеЗаполнено(ТекСтрока.Пункт), ТекСтрока.Пункт, ТекСтрока.ЗаказГрузоотправителя.АдресНазначения);
		Иначе
			ТекПункт = ТекСтрока.Пункт;
		КонецЕсли;
		
		Если ТекСтрока.ЗаказГрузоотправителя.Пустая() Или ТекСтрока.ТипТочкиМаршрута.Пустая() Тогда
			НовСтрокаПункт = дЗаказыДерево.Строки.Добавить();
			НовСтрокаПункт.ПунктЗаказНоменклатура = ТекПункт;
			НовСтрокаПункт.Расстояние             = ТекСтрока.Расстояние;
			НовСтрокаПункт.ПрибытиеФакт           = ТекСтрока.ПрибытиеФакт;
			НовСтрокаПункт.УбытиеФакт             = ТекСтрока.УбытиеФакт;
			НовСтрокаПункт.ПрибытиеПлан           = ТекСтрока.ПрибытиеПлан;
			НовСтрокаПункт.Время                  = ТекСтрока.Время;
			
			ПредПункт     = ТекПункт;
			СменилсяПункт = Истина;
			
			Если дЗаказыДерево.Строки.Индекс(НовСтрокаПункт) = 0 Тогда
				НовСтрокаПункт.УбытиеПлан = МаршрутныйЛист.ДатаИВремяОтправленияПлан;
			КонецЕсли;
			
			Продолжить;
		КонецЕсли;
		
		Если Не ТекПункт = ПредПункт Или СменилсяПункт Тогда
			НовСтрокаПункт = дЗаказыДерево.Строки.Добавить();
			НовСтрокаПункт.ПунктЗаказНоменклатура = ТекПункт;
			НовСтрокаПункт.Расстояние             = ТекСтрока.Расстояние;
			НовСтрокаПункт.Время                  = ТекСтрока.Время;
			НовСтрокаПункт.ПрибытиеФакт           = ТекСтрока.ПрибытиеФакт;
			НовСтрокаПункт.УбытиеФакт             = ТекСтрока.УбытиеФакт;
			НовСтрокаПункт.ПрибытиеПлан           = ТекСтрока.ПрибытиеПлан;
			НовСтрокаПункт.СтоянкаИзПункта        = ТекСтрока.СтоянкаИзПункта;
			
			ПредПункт     = ТекПункт;
			СменилсяПункт = Истина;
			
			Если дЗаказыДерево.Строки.Индекс(НовСтрокаПункт) = 0 Тогда
				НовСтрокаПункт.УбытиеПлан = МаршрутныйЛист.ДатаИВремяОтправленияПлан;
			КонецЕсли;
		КонецЕсли;
		
		//Заказ
		Если Не ТекСтрока.ЗаказГрузоотправителя = ПредЗаказ 
			Или (Не ПредСтрока = Неопределено И Не ТекСтрока.ТипТочкиМаршрута = ПредСтрока.ТипТочкиМаршрута) 
			Или СменилсяПункт Тогда
				НовСтрокаЗаказ = НовСтрокаПункт.Строки.Добавить();
				НовСтрокаЗаказ.ПунктЗаказНоменклатура = ТекСтрока.ЗаказГрузоотправителя;
				НовСтрокаЗаказ.ЗаказГрузоотправителя  = ТекСтрока.ЗаказГрузоотправителя;
				НовСтрокаЗаказ.ТипТочкиМаршрута       = ТекСтрока.ТипТочкиМаршрута;
				НовСтрокаЗаказ.Стоянка                = ТекСтрока.Стоянка;
				НовСтрокаЗаказ.СтоянкаИзПункта        = ТекСтрока.СтоянкаИзПункта;
				
				ПредЗаказ     = ТекСтрока.ЗаказГрузоотправителя;
				СменилсяПункт = Ложь;
		КонецЕсли;
		
		Если ТекСтрока.ЗаказГрузоотправителя.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам Тогда
			НовСтрокаЗаказ.ЗаказГрузоотправителя = ТекСтрока.ЗаказГрузоотправителя;
		Иначе
			НовСтрокаНоменклатура = НовСтрокаЗаказ.Строки.Добавить();
			НовСтрокаНоменклатура.ПунктЗаказНоменклатура = ТекСтрока.Номенклатура;
			НовСтрокаНоменклатура.ЗаказГрузоотправителя  = ТекСтрока.ЗаказГрузоотправителя;
		КонецЕсли;
		
		ПредСтрока = ТекСтрока;
	КонецЦикла;
	
	Возврат дЗаказыДерево;
	
КонецФункции

Процедура ОбновитьМаршрутныеПараметрыДереваЗаказов(ДеревоЗаказов)
	
	ЭлементыДерева = ДеревоЗаказов.Строки;
	
	Если ЭлементыДерева.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПредВремяОтпр       = ЭлементыДерева[0].УбытиеПлан;
	ПредПунктСтрока     = Неопределено;
	СуммарноеВремя      = 0;
	ОбщееВремяСтоянок   = 0;
	
	Для Каждого ТекСтрокаПункт Из ЭлементыДерева Цикл
		СуммарноеВремяСтоянки = 0;
		
		Для Каждого ТекСтрокаЗаказ Из ТекСтрокаПункт.Строки Цикл 
			СуммарноеВремяСтоянки = уатЗащищенныеФункцииСервер.СложитьВремя(СуммарноеВремяСтоянки, ТекСтрокаЗаказ.Стоянка);
		КонецЦикла;
		
		СуммарноеВремяСтоянки = уатЗащищенныеФункцииСервер.СложитьВремя(СуммарноеВремяСтоянки, ТекСтрокаПункт.СтоянкаИзПункта);
		
		ТекСтрокаПункт.Стоянка = СуммарноеВремяСтоянки;
		ОбщееВремяСтоянок      = уатЗащищенныеФункцииСервер.СложитьВремя(ОбщееВремяСтоянок, ТекСтрокаПункт.Стоянка);
		
		Если ЭлементыДерева.Индекс(ТекСтрокаПункт) = 0 Тогда
			ТекСтрокаПункт.ПрибытиеПлан = уатЗащищенныеФункцииСервер.СложитьВремя(ТекСтрокаПункт.УбытиеПлан, -СуммарноеВремяСтоянки);
			ПредВремяОтпр               = ТекСтрокаПункт.УбытиеПлан;
		Иначе 
			ТекСтрокаПункт.ПрибытиеПлан = уатЗащищенныеФункцииСервер.СложитьВремя(ПредВремяОтпр,               ПредПунктСтрока.Время);
			ТекСтрокаПункт.УбытиеПлан   = уатЗащищенныеФункцииСервер.СложитьВремя(ТекСтрокаПункт.ПрибытиеПлан, СуммарноеВремяСтоянки);
			ПредВремяОтпр               = ТекСтрокаПункт.УбытиеПлан;
		КонецЕсли;
		
		ПредПунктСтрока = ТекСтрокаПункт;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
