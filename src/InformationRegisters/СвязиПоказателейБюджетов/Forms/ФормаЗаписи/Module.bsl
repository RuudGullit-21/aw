#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		ЗаполнитьВидыАналитикСтатьиБюджетов();
		ЗаполнитьВидыАналитикПоказателяБюджетов(Истина);
	КонецЕсли;
	
	Элементы.ГруппаБезКонтекста.Видимость = Не (Параметры.КонтекстМодельБюджетирования 
													Или Параметры.КонтекстСтатьяБюджетов
													Или Параметры.КонтекстСвязанныйПоказательБюджетов);
	
	Элементы.ГруппаКонтекстСтатьяБюджетов.Видимость              = Параметры.КонтекстСтатьяБюджетов;
	Элементы.ГруппаКонтекстСвязанныйПоказательБюджетов.Видимость = Параметры.КонтекстСвязанныйПоказательБюджетов;
	
	БюджетированиеСервер.ДополнитьУсловноеОформлениеНастройкамиОтображенияАналитик(
		УсловноеОформление,
		"Аналитика");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьВидыАналитикСтатьиБюджетов();
	ЗаполнитьВидыАналитикПоказателяБюджетов();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для каждого Строка Из Аналитика Цикл
		
		ЗначениеАналитики = ?(ЗначениеЗаполнено(Строка.ЗначениеАналитики), Строка.ЗначениеАналитики, Неопределено);
		
		ТекущийОбъект["Аналитика" + Строка.НомерАналитики]					 = ЗначениеАналитики;
		ТекущийОбъект["ТранслироватьАналитику" + Строка.НомерАналитики]		 = Строка.Транслировать;
		ТекущийОбъект["АдресТрансляцииАналитики" + Строка.НомерАналитики]	 = Строка.АдресТрансляцииАналитики;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатьяБюджетовПриИзменении(Элемент)
	
	СтатьяБюджетовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстСвязаннаяСтатьяБюджетовСвязанныйСтатьяБюджетовПриИзменении(Элемент)
	
	СтатьяБюджетовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныйПоказательБюджетовПриИзменении(Элемент)
	
	ЗаполнитьВидыАналитикПоказателяБюджетов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстСтатьяБюджетовСвязанныйПоказательБюджетовПриИзменении(Элемент)
	
	ЗаполнитьВидыАналитикПоказателяБюджетов(Истина);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыАналитика

&НаКлиенте
Процедура АналитикаПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СтатьяБюджетовПриИзмененииСервер()
	
	ЗаполнитьВидыАналитикСтатьиБюджетов();
	ОбновитьНастройкиТрансляцииАналитик();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыАналитикСтатьиБюджетов()
	
	ВидыАналитикСтатьиБюджетов.Очистить();
	
	Если Не ЗначениеЗаполнено(Запись.СтатьяБюджетов) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыСтатьиБюджетов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.СтатьяБюджетов, 
		"ВидАналитики1, ВидАналитики2, ВидАналитики3, ВидАналитики4, ВидАналитики5, ВидАналитики6");
		
	Для каждого Реквизит Из РеквизитыСтатьиБюджетов Цикл
		ВидыАналитикСтатьиБюджетов.Добавить(Реквизит.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыАналитикПоказателяБюджетов(УстанавливатьПризнакТранслировать = Ложь)
	
	Если Аналитика.Количество() > 0 Тогда
		Аналитика.Очистить();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.СвязанныйПоказательБюджетов) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыСтатьиБюджетов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.СвязанныйПоказательБюджетов, 
		"ВидАналитики1, ВидАналитики2, ВидАналитики3, ВидАналитики4, ВидАналитики5, ВидАналитики6");
	
	Для НомерАналитики = 1 По 6 Цикл
		
		ВидАналитики = РеквизитыСтатьиБюджетов["ВидАналитики" + НомерАналитики];
		
		Если Не ЗначениеЗаполнено(ВидАналитики) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаАналитики = ВидыАналитикСтатьиБюджетов.НайтиПоЗначению(ВидАналитики);
		МожноТранслировать = (СтрокаАналитики <> Неопределено);
		
		Если МожноТранслировать Тогда
			АдресТрансляцииАналитики = ВидыАналитикСтатьиБюджетов.Индекс(СтрокаАналитики);
		КонецЕсли;
		
		Транслировать = ?(УстанавливатьПризнакТранслировать, 
							МожноТранслировать, 
							Запись["ТранслироватьАналитику" + НомерАналитики] И МожноТранслировать);
		
		НоваяСтрока = Аналитика.Добавить();
		НоваяСтрока.НомерАналитики		 = НомерАналитики; 
		НоваяСтрока.ВидАналитики		 = ВидАналитики;
		НоваяСтрока.ЗначениеАналитики	 = Запись["Аналитика" + НомерАналитики];
		НоваяСтрока.Транслировать		 = Транслировать;
		НоваяСтрока.МожноТранслировать	 = МожноТранслировать;
		Если МожноТранслировать Тогда
			НоваяСтрока.АдресТрансляцииАналитики = АдресТрансляцииАналитики + 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиТрансляцииАналитик()
	
	Для каждого Строка Из Аналитика Цикл
		
		СтрокаАналитики = ВидыАналитикСтатьиБюджетов.НайтиПоЗначению(Строка.ВидАналитики);
		МожноТранслировать = (СтрокаАналитики <> Неопределено);
		
		Строка.МожноТранслировать = МожноТранслировать;
		Строка.Транслировать      = МожноТранслировать;
		Если МожноТранслировать Тогда
			АдресТрансляцииАналитики = ВидыАналитикСтатьиБюджетов.Индекс(СтрокаАналитики);
			Строка.АдресТрансляцииАналитики = АдресТрансляцииАналитики + 1;
		Иначе
			Строка.АдресТрансляцииАналитики = Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти