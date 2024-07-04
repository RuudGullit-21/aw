#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.АдресСервера = ЛицензированиеСервер.АдресСервераЛицензированияКонстанта();
	Объект.КодДоступаКлючаЗащиты = ЛицензированиеСервер.КодДоступаКлючаЗащиты();
	Объект.ДнейДоОкончанияДействияКлюча = ЛицензированиеСервер.ДнейДоОкончанияДействияКлюча();
	
	// проверка доступности локальной системы лицензирования
	Результат = ЛицензированиеСервер.ЛокальнаяСистемаЛицензированияДоступна(ОписаниеОшибки);
	Если Результат = Неопределено Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = ОписаниеОшибки;
		Сообщение.Сообщить();
		ЛицензированиеСервер.ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки);
		// И считаем, что недоступна
		ЛокальнаяСистемаЛицензированияДоступна = Ложь;
	Иначе
		ЛокальнаяСистемаЛицензированияДоступна = Результат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.АдресСервера) ИЛИ ВРег(Объект.АдресСервера) = "*LOCAL" Тогда
		Объект.РежимСтарта = 0;
	ИначеЕсли ВРег(Объект.АдресСервера) = "*AUTO" Тогда
		Объект.РежимСтарта = 1;
		Элементы.КодДоступаКлючаЗащиты.Доступность = Ложь;
		Объект.КодДоступаКлючаЗащиты = "";
	Иначе
		Объект.РежимСтарта = 2;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СисИнфо = Новый СистемнаяИнформация;
	ЭтоWindows = СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64;

	Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Если ЭтоWindows Тогда
		ПереходКСтранице(Элементы.СтраницаВыборРежима);
		РежимСтартаПриИзменении(Элементы.РежимСтарта);
	Иначе
		ПереходКСтранице(Элементы.СтраницаУказатьАдрес);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Переход к странице формы
// Параметры
//   Страница - ГруппаФормы - страница, на которую будет осуществлен переход.
&НаКлиенте
Процедура ПереходКСтранице(Страница)
	Для Каждого ТекСтраница Из Элементы.ГруппаСтраницы.ПодчиненныеЭлементы Цикл
		ТекСтраница.Видимость = Ложь;
	КонецЦикла;
	Страница.Видимость = Истина;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Страница;
	
	ТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;
	Если  ТекущаяСтраница = Элементы.СтраницаВыборРежима Тогда
		Элементы.ФормаКомандаНазад.Доступность = Ложь;
	Иначе
		Элементы.ФормаКомандаНазад.Доступность = Истина;
	КонецЕсли;
	
	Если ТекущаяСтраница = Элементы.СтраницаУказатьАдрес И НЕ ЭтоWindows Тогда
		Элементы.ФормаКомандаНазад.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресСервераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    СписокСерверов = СписокСерверов(ОписаниеОшибки);
	СписокСерверов.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("АдресСервераНачалоВыбораЗавершение", ЭтотОбъект), НСтр("ru = 'Выберите сервер лицензирования'; en = 'Select the license server'"));
КонецПроцедуры

&НаКлиенте
Процедура АдресСервераНачалоВыбораЗавершение(ВыбранныйЭлемент1, ДополнительныеПараметры) Экспорт
	
	ВыбранныйЭлемент = ВыбранныйЭлемент1;
	Объект.АдресСервера = ?(ВыбранныйЭлемент = Неопределено, Объект.АдресСервера, ВыбранныйЭлемент.Значение);

КонецПроцедуры

&НаКлиенте
Процедура РежимСтартаПриИзменении(Элемент)
	Если Объект.РежимСтарта = 0 Тогда
		Элементы.ДекорацияРежимСтарта.Заголовок = НСтр("ru = 'Этот вариант следует выбирать в случае работы в локальном режиме: то есть на одном рабочем месте, без использования сети. 
		|Если используется аппаратный ключ защиты, то его следует подключать к этому компьютеру. 
		|Если же используется программный ключ защиты, то его следует активировать на данном компьютере.
		|(При использовании серверной базы данных сервер лицензирования должен быть установлен на одном компьютере с сервером 1С,
		|а при использовании нескольких серверов в кластере - на каждом сервере кластера.)'");
	ИначеЕсли Объект.РежимСтарта = 2 Тогда
		Элементы.ДекорацияРежимСтарта.Заголовок = НСтр("ru = 'Этот вариант используется в сетевом режиме. 
		|Если он выбран, то следует указать сетевой адрес компьютера, на котором установлен сервер лицензирования.
		|По умолчанию сервер лицензирования устанавливается на сетевой порт 15200.'");
	Иначе
		Элементы.ДекорацияРежимСтарта.Заголовок = НСтр("ru = 'Этот вариант используется только при наличии в сети настроенных серверов лицензирования. 
		|При использовании данного варианта происходит автоматический поиск серверов лицензирования в сети.
		|В этом режиме невозможна активация программного ключа.'");
	КонецЕсли;
	
	Если Объект.РежимСтарта = 1 Тогда
		Объект.КодДоступаКлючаЗащиты = "";
		Элементы.КодДоступаКлючаЗащиты.Видимость = Ложь;
	Иначе
		Элементы.КодДоступаКлючаЗащиты.Видимость = Истина;
	КонецЕсли;
	
	Если Объект.РежимСтарта = 0 Тогда
		Элементы.АдресСервера.Видимость = Ложь;
		Элементы.ДекорацияАдресСервера.Видимость = Ложь;
	Иначе
		Элементы.АдресСервера.Видимость = Истина;
		Элементы.ДекорацияАдресСервера.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВперед(Команда)
	ОбработкаДействия("Вперед");
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	ОбработкаДействия("Назад");
КонецПроцедуры

&НаКлиенте
Процедура КомандаНайтиСервера(Команда)
	СписокСерверов = ЛицензированиеСервер.СервераЛицензирования("",ОписаниеОшибки);
	СписокСерверов.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("КомандаНайтиСервераЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КомандаНайтиСервераЗавершение(ВыбранныйЭлемент1, ДополнительныеПараметры) Экспорт
	
	ВыбранныйЭлемент = ВыбранныйЭлемент1;
	Объект.АдресСервера = ?(ВыбранныйЭлемент = Неопределено, Объект.АдресСервера, ВыбранныйЭлемент.Значение);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработка действия пользователя
&НаКлиенте
Процедура ОбработкаДействия(Действие)
	Страницы = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы;
	ТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Страницы.СтраницаВыборРежима Тогда
		Если Объект.РежимСтарта = 0 Тогда //LOCAL
			
			Если НЕ ЛокальнаяСистемаЛицензированияДоступна Тогда
				ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Недоступен сервер лицензирования на локальном компьютере.
                                     |Необходимо запустить или выполнить установку сервера лицензирования.'; en = 'The license server is not available on your computer.
                                     || You need to run or install the license server.'"));
				Возврат;
			КонецЕсли;	
			Элементы.ДекорацияИзменениеСервера.Заголовок = НСтр("ru = 'Будет выполнено подключение к локальному серверу лицензирования.'; en = 'It will connect to the local server licensing.'"); 
			Объект.АдресСервера = "*LOCAL";	
			ПереходКСтранице(Элементы.СтраницаУказатьАдрес); // нужно указать код ключа										   
		
		ИначеЕсли Объект.РежимСтарта = 1 Тогда //AUTO
		
			Элементы.ДекорацияИзменениеСервера.Заголовок = НСтр("ru = 'Будет выполнен поиск сервера лицензирования в сети и подключение к найденному серверу'; en = 'It will search the license server on the network and connect to servers found'");
			Объект.АдресСервера = "*AUTO";                                               
			ПереходКСтранице(Элементы.СтраницаПредупреждение);												
		
		ИначеЕсли Объект.РежимСтарта = 2 Тогда //Адрес
			
			Объект.АдресСервера = ЛицензированиеСервер.АдресСервераЛицензированияКонстанта();
			ПереходКСтранице(Страницы.СтраницаУказатьАдрес);
			
		КонецЕсли;
			
	ИначеЕсли ТекущаяСтраница = Страницы.СтраницаУказатьАдрес Тогда
		Если Действие = "Вперед" Тогда
			Если ПустаяСтрока(Объект.АдресСервера) Тогда
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Укажите адрес сервера лицензирования'; en = 'Specify the address of the license server'");
				Сообщение.Сообщить();				
				ЛицензированиеСервер.ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки);
				Возврат;
			КонецЕсли;
			
			Элементы.ДекорацияИзменениеСервера.Заголовок = НСтр("ru = 'Будет выполнено подключение к серверу лицензирования ""'; en = 'It will connect to the license server ""'") + Объект.АдресСервера + """ ";
															
			ПереходКСтранице(Элементы.СтраницаПредупреждение);												
															
		Иначе //Назад
			ПереходКСтранице(Страницы.СтраницаВыборРежима);
		КонецЕсли;
	ИначеЕсли ТекущаяСтраница = Страницы.СтраницаПредупреждение Тогда
		
		Если Действие = "Вперед" Тогда
			ЛицензированиеСервер.УстановитьАдресСервераЛицензирования(Объект.АдресСервера);
			ЛицензированиеСервер.УстановитьКодДоступаКлючаЗащиты(Объект.КодДоступаКлючаЗащиты);
			ЛицензированиеСервер.УстановитьДнейДоОкончанияДействияКлюча(Объект.ДнейДоОкончанияДействияКлюча);
			Оповестить("СерверЛицензирования",Объект.АдресСервера);
			Закрыть("");
		Иначе
			Если Объект.РежимСтарта = 1 Тогда
				ПереходКСтранице(Страницы.СтраницаВыборРежима);
			Иначе
				ПереходКСтранице(Страницы.СтраницаУказатьАдрес);
			КонецЕсли;
		КонецЕсли;
	Иначе
	КонецЕсли;
		
КонецПроцедуры

// Возвращает список серверов лицензирования, найденных в локальной сети  
&НаСервереБезКонтекста
Функция СписокСерверов(ОписаниеОшибки)
	Возврат ЛицензированиеСервер.СервераЛицензирования("", ОписаниеОшибки);
КонецФункции

#КонецОбласти

