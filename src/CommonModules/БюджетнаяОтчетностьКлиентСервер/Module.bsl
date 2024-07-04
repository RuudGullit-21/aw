
#Область СлужебныйПрограммныйИнтерфейс

// Функция создает хранилище со стандартной структурой
// элемента бюджетного отчета на основании ссылки или строки
// вида бюджета
//
// Параметры:
//  Элемент  - ДанныеФормыСтрокаДерева или СправочникСсылка.ЭлементыФинансовыхОтчетов - помещаемое значение
//  АдресХранилища - УИД - УИД формы вида бюджета
//
// Возвращаемое значение:
//   Строка - Адрес в хранилище
//
Функция ПоместитьЭлементВХранилище(Элемент, АдресХранилища) Экспорт
	
	// Если формируем хранилище на основании строки - 
	// тогда формируем по элементу, если есть, иначе по самой строке
	Если ТипЗнч(Элемент) = Тип("ДанныеФормыЭлементДерева")
		ИЛИ ТипЗнч(Элемент) = Тип("ДанныеФормыЭлементКоллекции")
		ИЛИ ТипЗнч(Элемент) = Тип("СтрокаДереваЗначений") Тогда
		
		Если ЗначениеЗаполнено(Элемент.ЭлементОтчета) Тогда
			
			Возврат ФинансоваяОтчетностьВызовСервера.ПоместитьЭлементВХранилище(Элемент.ЭлементОтчета, АдресХранилища);
			
		Иначе
			
			СтруктураЭлемента = ФинансоваяОтчетностьКлиентСервер.СтруктураЭлементаОтчета();
			ЗаполнитьЗначенияСвойств(СтруктураЭлемента, Элемент);
			
			Если СтруктураЭлемента.ВидЭлемента = ВидЭлемента("СтатьяБюджетов")
				ИЛИ СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ВсеСтатьиБюджетов") Тогда
				
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_СтатьяБюджетов", Элемент.СтатьяПоказательТипИзмерения);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыводимыеПоказатели", Элемент.ВыводимыеПоказатели);
				
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ПериодичностьСмещения", ПредопределенноеЗначение("Перечисление.Периодичность.Год"));
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_НижняяГраницаДанных", "[Начало периода данных]");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВерхняяГраницаДанных", "[Конец периода данных]");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_НачалоПериодаГруппировки", "[Период группировки]");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КонецПериодаГруппировки", "[Период группировки]");
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ПоказательБюджетов")
				ИЛИ СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ВсеПоказателиБюджетов") Тогда
				
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ПоказательБюджетов", Элемент.СтатьяПоказательТипИзмерения);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыводимыеПоказатели", Элемент.ВыводимыеПоказатели);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ТипЗначенияПоказателя", Элемент.ТипЗначенияПоказателя);
				
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ПериодичностьСмещения", ПредопределенноеЗначение("Перечисление.Периодичность.Год"));
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_НижняяГраницаДанных", "[Начало периода данных]");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВерхняяГраницаДанных", "[Конец периода данных]");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_НачалоПериодаГруппировки", "[Период группировки]");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КонецПериодаГруппировки", "[Период группировки]");
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("Группа") Тогда
				
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыводитьЗаголовокЭлемента", Истина);
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ФормулаПоГруппе") Тогда
				
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ФормулаПоГруппе", ПредопределенноеЗначение("Перечисление.ВидыФормулБюджетирования.Сумма"));
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ПроизводныйПоказатель") Тогда
				
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Формула", "");
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("Измерение") Тогда
				
				ТипИзмерения = ОпределитьТипИзмеренияПоТипуЗначения(Элемент.СтатьяПоказательТипИзмерения, Элемент);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ТипИзмерения", 	ТипИзмерения);
				Если ТипИзмерения = ТипИзмерения("ИзмерениеРегистра") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ИмяИзмерения", 	Элемент.СтатьяПоказательТипИзмерения);
				ИначеЕсли ТипИзмерения = ТипИзмерения("Период") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Периодичность", 	Элемент.СтатьяПоказательТипИзмерения);
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ЗначениеПериода", 	Элемент.ЗначениеАналитики);
				ИначеЕсли ТипИзмерения = ТипИзмерения("ФиксированнаяАналитика") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВидАналитики", 	Элемент.СтатьяПоказательТипИзмерения);
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ЭтоАналитикаПрочее", Элемент.ЭтоАналитикаПрочее);
				ИначеЕсли ТипИзмерения = ТипИзмерения("Аналитика") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВидАналитики", 	Элемент.СтатьяПоказательТипИзмерения);
				ИначеЕсли ТипИзмерения = ТипИзмерения("Сценарий") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Сценарий", 		Элемент.СтатьяПоказательТипИзмерения);
				ИначеЕсли ТипИзмерения = ТипИзмерения("Валюта") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Валюта", 		Элемент.СтатьяПоказательТипИзмерения);
				ИначеЕсли ТипИзмерения = ТипИзмерения("Организация") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Организация", 	Элемент.СтатьяПоказательТипИзмерения);
				ИначеЕсли ТипИзмерения = ТипИзмерения("Подразделение") Тогда
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Подразделение", 	Элемент.СтатьяПоказательТипИзмерения);
				КонецЕсли;
				
			КонецЕсли;
			
			Возврат ФинансоваяОтчетностьВызовСервера.ПоместитьЭлементВХранилище(СтруктураЭлемента, АдресХранилища);
			
		КонецЕсли;
	Иначе
		Возврат ФинансоваяОтчетностьВызовСервера.ПоместитьЭлементВХранилище(Элемент, АдресХранилища);
	КонецЕсли;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Функция определяет тип измерения бюджетного отчета
//
// Параметры:
//  Значение  - Произвольный - значение измерения бюджетного отчета
//                             на основании которого определяется тип измерения
//  ДополнительныеПараметры  - Структура - дополнительные сведения
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ТипыИзмеренийБюджетныхОтчетов - тип измерения
//
Функция ОпределитьТипИзмеренияПоТипуЗначения(Значение, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Значение) = Тип("ПеречислениеСсылка.Периодичность") Тогда
		
		Возврат ТипИзмерения("Период");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ПланВидовХарактеристикСсылка.АналитикиСтатейБюджетов") Тогда
		
		Если ДополнительныеПараметры <> Неопределено
			И (ЗначениеЗаполнено(ДополнительныеПараметры.ЗначениеАналитики) 
			ИЛИ ДополнительныеПараметры.ЭтоАналитикаПрочее) Тогда
			Возврат ТипИзмерения("ФиксированнаяАналитика");
		Иначе
			Возврат ТипИзмерения("Аналитика");
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Сценарии") Тогда
		
		Возврат ТипИзмерения("Сценарий");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Организации") Тогда
		
		Возврат ТипИзмерения("Организация");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		
		Возврат ТипИзмерения("Подразделение");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Валюты") Тогда
		
		Возврат ТипИзмерения("Валюта");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
				
		Возврат ТипИзмерения("ЕдиницаИзмерения");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		
		Возврат ТипИзмерения("ИзмерениеРегистра");
		
	Иначе
		
		ТекстНСТР = НСтр("en='Unknown dimension type budget report';ru='Неизвестный тип измерения бюджетного отчета'");
		ВызватьИсключение ТекстНСТР;
		
	КонецЕсли;
	
КонецФункции

// Процедура заполняет строку списка или дерева элементов отчета
// дополнительными реквизитами
//
// Параметры:
//  Результат - структура - источник заполнения
//  СтрокаПриемник - ДанныеФормыСтрокаДерева - строка, которую заполняем
//  АдресЭлементаВХранилище - строка - адрес хранилища элемента
//  Поле - ДанныеФормыКоллекция - для поиска строки, если приемник - идентификатор строки
//
Процедура ЗаполнитьСтрокуСпискаЭлементовОтчета(Знач Результат, Знач СтрокаПриемник, АдресЭлементаВХранилище = Неопределено, Поле = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Форма возвращает актуальные реквизиты
	Если ТипЗнч(СтрокаПриемник) = Тип("Число") Тогда
		СтрокаПриемник = Поле.НайтиПоИдентификатору(СтрокаПриемник);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаПриемник, Результат);
	ДополнительныеРеквизитыСписка = "ВыводимыеПоказатели, ТипЗначенияПоказателя, ВыводитьЗаголовокЭлемента";
	Если Не ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		ДополнительныеРеквизиты = 
				ФинансоваяОтчетностьВызовСервера.ЗначенияДополнительныхРеквизитов(
													Результат,
													ДополнительныеРеквизитыСписка);
	Иначе
		// Но актуальные значения дополнительных реквизитов формируются на сервере
		// в ПередЗаписьюНаСервере, соответственно находятся в хранилище
		ДополнительныеРеквизиты = 
				ФинансоваяОтчетностьВызовСервера.ЗначенияДополнительныхРеквизитов(
													АдресЭлементаВХранилище,
													ДополнительныеРеквизитыСписка);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаПриемник, ДополнительныеРеквизиты);
	
КонецПроцедуры

// Функция возвращает представление смещения
//
// Параметры:
//  Период  - Число - количество периодов смещения
//  Периодичность  - ПеречислениеСсылка.Периодичность - периодичность смещения
//
// Возвращаемое значение:
//   Строка   - представление смещения
//
Функция ПредставлениеСмещения(Форма, ЗначениеПустое = Ложь) Экспорт
	
	ЗначениеПустое = Ложь;
	
	Периодичность = Форма.ПериодичностьСмещения;
	Период = Форма.ПериодСмещения;
	
	Если Период = 0 Тогда
		ПредставлениеПериод = "";
	Иначе
		ТекстНСТР = НСтр("en='Data offset at %1 back';ru='Данные смещены на %1 назад'");
		ПредставлениеПериод = БюджетированиеКлиентСервер.ПериодЦифрамиПериодичностьПрописью(Период, Периодичность);
		ПредставлениеПериод = СтрШаблон(ТекстНСТР, ПредставлениеПериод);
	КонецЕсли;
	
	ЕстьИзмененияГраниц = Ложь;
	
	Если ЗначениеЗаполнено(Форма.НижняяГраницаДанных)
		И Форма.НижняяГраницаДанных <> "[Начало периода данных]" Тогда
		
		ЕстьИзмененияГраниц = Истина;
		
	ИначеЕсли ЗначениеЗаполнено(Форма.ВерхняяГраницаДанных)
		И Форма.ВерхняяГраницаДанных <> "[Конец периода данных]" Тогда
		
		ЕстьИзмененияГраниц = Истина;
		
	ИначеЕсли ЗначениеЗаполнено(Форма.НачалоПериодаГруппировки)
		И Форма.НачалоПериодаГруппировки <> "[Период группировки]" Тогда
		
		ЕстьИзмененияГраниц = Истина;
		
	ИначеЕсли ЗначениеЗаполнено(Форма.КонецПериодаГруппировки)
		И Форма.КонецПериодаГруппировки <> "[Период группировки]" Тогда
		
		ЕстьИзмененияГраниц = Истина;
		
	КонецЕсли;
	
	ПредставлениеГраниц = "";
	Если ЕстьИзмененияГраниц Тогда
		ПредставлениеГраниц = НСтр("en='The boundaries of the period are set';ru='Установлены границы периода'");
	КонецЕсли;
	
	Если ПредставлениеГраниц = ""
		И ПредставлениеПериод = "" Тогда
		
		Результат = НСтр("en='Offset and data boundary is not set';ru='Смещение и границы данных не заданы'");
		ЗначениеПустое = Истина;
		
	ИначеЕсли ПредставлениеПериод <> ""
		И ПредставлениеГраниц <> "" Тогда
		
		Результат = ПредставлениеПериод + ", " + НРег(ПредставлениеГраниц);
		
	ИначеЕсли ПредставлениеПериод <> "" Тогда
		
		Результат = ПредставлениеПериод;
		
	ИначеЕсли ПредставлениеГраниц <> "" Тогда
		
		Результат = ПредставлениеГраниц;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Функция возвращает цвет стиля
//
// Параметры:
//  ЛокальныйКэш  - Соответствие - локальный кэш для хранения соответствия имен
//                                 и цветов, что бы не обращаться к серверу в случае
//                                 клиентского вызова
//  ИмяЦвета  - Строка - имя цвета
//
// Возвращаемое значение:
//   Цвет   - Цвет стиля по имени
//
Функция ПолучитьЦветСтиля(ЛокальныйКэш, ИмяЦвета) Экспорт
	Перем Цвет;
	
	Если ЛокальныйКэш = Неопределено Тогда
		ЛокальныйКэш = Новый Структура;
	КонецЕсли;
	
	Если ЛокальныйКэш.Свойство(ИмяЦвета, Цвет) Тогда
		Возврат Цвет;
	КонецЕсли;
	
	Цвет = БюджетнаяОтчетностьВызовСервера.ПолучитьЦвет(ИмяЦвета);
	ЛокальныйКэш.Вставить(ИмяЦвета, Цвет);
	
	Возврат Цвет;
	
КонецФункции

Функция ВидЭлемента(ИмяВидаЭлемента)
	
	Возврат ПредопределенноеЗначение("Перечисление.ВидыЭлементовФинансовогоОтчета."+ИмяВидаЭлемента);
	
КонецФункции

Функция ТипИзмерения(ИмяВидаЭлемента)
	
	Возврат ПредопределенноеЗначение("Перечисление.ТипыИзмеренийФинансовогоОтчета."+ИмяВидаЭлемента);
	
КонецФункции

Функция ЛеваяЧастьИмениСовпадает(Имя, ИскомаяСтрока) Экспорт
	
	Возврат Лев(Имя, СтрДлина(ИскомаяСтрока)) = ИскомаяСтрока;
	
КонецФункции

Функция ПараметрыОткрытияФормыНастройкиПериода(Форма, ДополнятьЭлементамиОтчета = Истина) Экспорт
	
	ЗаполняемыеПоля = "ПериодСмещения, ПериодичностьСмещения, НижняяГраницаДанных,
						|ВерхняяГраницаДанных, НачалоПериодаГруппировки, КонецПериодаГруппировки" + 
						?(ДополнятьЭлементамиОтчета, "
						|, АдресТаблицыЭлементов, АдресРедактируемогоЭлемента
						|, АдресЭлементовОтчета, ВариантРасположенияГраницыФактическихДанных", "");
	
	Параметры = Новый Структура(ЗаполняемыеПоля);
	ЗаполнитьЗначенияСвойств(Параметры, Форма);
	
	Возврат Параметры;
	
КонецФункции

Функция ПараметрыОткрытияФормыНастройкиПериодичностиПланирования(ФормаОбъект) Экспорт
	
	ЗаполняемыеПоля = "Периодичность, СпособПланирования, ВариантРасположенияГраницыФактическихДанных,
						|КоличествоПериодовСкользящегоБюджета, СмещениеГраницыФакта, ПериодичностьГраницыФакта";
	
	Параметры = Новый Структура(ЗаполняемыеПоля);
	ЗаполнитьЗначенияСвойств(Параметры, ФормаОбъект);
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

